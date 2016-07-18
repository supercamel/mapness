/*
    Copyright (C) 2016 Samuel Cowen <samuel.cowen@camelsoftware.com>

    After making several contributions to the OsmGpsMap, I decided to create a
    new mapping widget using the Vala language. The benefits of Vala are
     - faster and less tedious to develop with
     - similar performance to C
     - it's harder to write buggy code with
     - generates very clean bindings with gir

    Mapness was, of course, heavily inspired by the OsmGpsMap widget.

    Please see https://github.com/nzjrs/osm-gps-map
    for the list of original authors.

    This file is part of mapness.

    Foobar is free software: you can redistribute it and/or modify
    it under the terms of the Lesser GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Foobar is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    Lesser GNU General Public License for more details.

    You should have received a copy of the Lesser GNU General Public License
    along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
*/

using Gtk;
using GLib;

namespace mapness
{

public class Map: DrawingArea
{
    //string get_default_cache_dir();
    //void download_maps(Point p1, Point p1, int zoom_start);


    public Map()
    {
        map_source = Source.GoogleHybrid;
        repo_uri = map_source.get_uri();
        uri_format = get_uri_format(repo_uri);
        cache_dir = get_default_cache_dir();
        image_format = map_source.get_format();

        redraw_cycles = 0;
        redraw_flag = true;
        zoom_max = 17;
        zoom_min = 2;
        is_button_down = false;
        is_dragging_point = false;
        scroll_wheel = true;
        show_zoom_control = true;

        zoom_control = new ZoomControl();
        zoom_control.zoom_changed.connect((change) => { set_zoom(map_zoom+change); });
        zoom_control.redraw.connect(() => { redraw_canvas(); });

        set_center_and_zoom(new Point.degrees(0, 0), 12);

        tile_queue = new GLib.SList<string>();
        missing_tiles = new GLib.SList<string>();
        tile_cache = new GLib.HashTable<string, CachedTile?>(str_hash, str_equal);

        tracks = new GLib.SList<Track>();

        session = new Soup.Session();
        session.user_agent = "mapnip";

        add_events(Gdk.EventMask.BUTTON_PRESS_MASK);
        add_events(Gdk.EventMask.BUTTON_RELEASE_MASK);
        add_events(Gdk.EventMask.SCROLL_MASK);
        add_events(Gdk.EventMask.POINTER_MOTION_MASK);
        button_press_event.connect ((e) => {
            if(show_zoom_control == true)
            {
                if(zoom_control.on_click(e) == true)
                    return false;
            }

            foreach(var layer in layers)
            {
                if(layer.on_click(e) == true)
                    return false;
            }
            if((int)e.button == 1)
            {
                is_button_down = true;
                foreach(var track in tracks)
                {
                    if(check_track_click(e, track, false))
                        return false;
                }
                foreach(var poly in polygons)
                {
                    if(check_track_click(e, poly, true))
                        return false;
                }
                drag_start_x = (int)e.x;
                drag_start_y = (int)e.y;
            }
            return false;
        });

        button_release_event.connect((e) => {
            if(is_button_down == false)
                return false;

            if((int)e.button == 1)
            {
                is_button_down = false;
                drag_mouse_dx = 0;
                drag_mouse_dy = 0;
                if(is_dragging_point == true)
                {
                    is_dragging_point = false;
                    Point pt;
                    screen_to_geographic((int)e.x, (int)e.y, out pt);
                    drag_point.rlat = pt.rlat;
                    drag_point.rlon = pt.rlon;
                    drag_track.point_changed(drag_point);
                    idle_redraw();
                    return false;
                }
                int diff_x = (int)e.x-drag_start_x;
                int diff_y = (int)e.y-drag_start_y;

                map_x -= diff_x;
                map_y -= diff_y;
                update_center_coord();
                idle_redraw();
            }
            return false;
        });
        scroll_event.connect((e) => {
            if(scroll_wheel == false)
                return false;

            Point pt;
            screen_to_geographic((int)e.x, (int)e.y, out pt);
            Point center = new Point.radians(center_rlat, center_rlon);

            if(e.direction == Gdk.ScrollDirection.UP)
            {
                Point p = new Point.degrees(center.get_lat() + ((pt.get_lat() - center.get_lat())/2.0),
                            center.get_lon() + ((pt.get_lon() - center.get_lon())/2.0));
                if(map_zoom < zoom_max)
                    set_center_and_zoom(p, map_zoom+1);
            }
            else
            {
                Point p = new Point.degrees(center.get_lat() + ((center.get_lat() - pt.get_lat())*1.0),
                            center.get_lon() + ((center.get_lon() - pt.get_lon())*1.0));
                if(map_zoom > zoom_min)
                    set_center_and_zoom(p, map_zoom-1);
            }

            idle_redraw();
            return false;
            });

        motion_notify_event.connect((e) => {
            if(show_zoom_control)
            {
                if(zoom_control.on_motion(e) == true)
                    return false;
            }

            Point pt;
            screen_to_geographic((int)e.x, (int)e.y, out pt);

            if(is_dragging_point)
            {
                drag_point.rlat = pt.rlat;
                drag_point.rlon = pt.rlon;
                redraw_canvas();
            }
            else
            {
                if(is_button_down == true)
                {
                    drag_mouse_dx = (int)e.x-drag_start_x;
                    drag_mouse_dy = (int)e.y-drag_start_y;
                    redraw_canvas();
                }
            }
            return false;
            });
    }

    private bool redraw_canvas ()
    {
        var window = get_window ();
        if (null == window)
            return false;

        var region = window.get_clip_region ();
        window.invalidate_region (region, true);
        window.process_updates (true);
        return false;
    }

    public void set_source(Source source)
    {
        map_source = source;
        repo_uri = map_source.get_uri();
        uri_format = get_uri_format(repo_uri);
        cache_dir = get_default_cache_dir();
        image_format = map_source.get_format();
        idle_redraw();
    }

    public void add_image(Image img)
    {
        images.append(img);
        idle_redraw();
    }

    public void remove_image(Image img)
    {
        images.remove(img);
        idle_redraw();
    }

    public void add_track(Track track)
    {
        tracks.append(track);
        idle_redraw();
    }

    public void remove_track(Track track)
    {
        tracks.remove(track);
        idle_redraw();
    }

    public void add_polygon(Polygon poly)
    {
        polygons.append(poly);
        idle_redraw();
    }

    public void remove_polygon(Polygon poly)
    {
        polygons.remove(poly);
        idle_redraw();
    }

    public void add_layer(Layer layer)
    {
        layers.append(layer);
        idle_redraw();
    }

    public void remove_layer(Layer layer)
    {
        layers.remove(layer);
        idle_redraw();
    }

    public void idle_redraw()
    {
        if(redraw_flag)
        {
            redraw_flag = false;
            GLib.Idle.add(redraw_canvas);
        }
    }

    public string get_default_cache_dir()
    {
        return GLib.Path.build_filename(GLib.Environment.get_user_cache_dir(), "mapnip", map_source.to_string());
    }

    public void download_maps(Point pt1, Point pt2, int zoom_start, int zoom_end)
    {
        zoom_end = zoom_end.clamp(zoom_min, zoom_max);
        zoom_start = zoom_start.clamp(zoom_min, zoom_max);

        for(int zoom = zoom_start; zoom <= zoom_end; zoom++)
        {
            int x1 = 0;
            int y1 = 0;
            int x2 = 0;
            int y2 = 0;

            x1 = (int)Math.floor((double)lon2pixel(zoom, pt1.rlon) / (double)TILESIZE);
            y1 = (int)Math.floor((double)lat2pixel(zoom, pt1.rlat) / (double)TILESIZE);

            x2 = (int)Math.floor((double)lon2pixel(zoom, pt2.rlon) / (double)TILESIZE);
            y2 = (int)Math.floor((double)lat2pixel(zoom, pt2.rlat) / (double)TILESIZE);

            if ( (x2-x1) * (y2-y1) > MAX_DOWNLOAD_TILES )
            {
                GLib.warning("Aborting download of zoom level %d and up, because number of tiles would exceed %d", zoom, MAX_DOWNLOAD_TILES);
                break;
            }

            for(int i = x1; i <= x2; i++)
            {
                for(int j = y1; j <= y2; j++)
                {
                    string filename = "%s%c%d%c%d%c%d.%s".printf(
                                          cache_dir, GLib.Path.DIR_SEPARATOR,
                                          zoom, GLib.Path.DIR_SEPARATOR,
                                          i, GLib.Path.DIR_SEPARATOR,
                                          j,
                                          image_format);
                    if (!GLib.FileUtils.test(filename, GLib.FileTest.EXISTS))
                    {
                        download_tile(zoom, i, j);
                    }
                }
            }
        }
    }

    public void set_map_source(Source s)
    {
        repo_uri = s.get_uri();
    }

    public void set_center(Point pt)
    {
        Gtk.Allocation allocation;
        get_allocation(out allocation);

        center_rlat = pt.rlat;
        center_rlon = pt.rlon;

        int pixel_x = lon2pixel(map_zoom, center_rlon);
        int pixel_y = lat2pixel(map_zoom, center_rlat);

        map_x = pixel_x - allocation.width/2;
        map_y = pixel_y - allocation.height/2;
        idle_redraw();
    }

    public void set_zoom(int zoom)
    {
        Gtk.Allocation allocation;
        get_allocation(out allocation);

        int width_center  = allocation.width / 2;
        int height_center = allocation.height / 2;

        map_zoom = zoom.clamp(zoom_min, zoom_max);
        //print(zoom.to_string() + " " + zoom_min.to_string() + " " + zoom_max.to_string() + "\n");

        map_x = lon2pixel(map_zoom, center_rlon) - width_center;
        map_y = lat2pixel(map_zoom, center_rlat) - height_center;

        idle_redraw();
    }

    public void set_center_and_zoom(Point pt, int zoom)
    {
        set_zoom(zoom);
        set_center(pt);
    }

    private bool check_track_click(Gdk.EventButton e, Track track, bool is_poly)
    {
        if(track.editable == true)
        {
            int counter = 0;
            int last_x = 0;
            int last_y = 0;
            int first_x = 0;
            int first_y = 0;
            foreach(var point in track.points)
            {
                int cx;
                int cy;
                geographic_to_screen(point, out cx, out cy);
                double dist_sqrd = (e.x-cx)*(e.x-cx) + (e.y-cy)*(e.y-cy);
                if(dist_sqrd <= ((DOT_RADIUS + 1) * (DOT_RADIUS + 1)))
                {
                    is_button_down = true;
                    drag_point = point;
                    drag_track = track;
                    is_dragging_point = true;
                    idle_redraw();
                    return true;
                }
                if(counter > 0)
                {
                    int ptx = (last_x+cx)/2;
                    int pty = (last_y+cy)/2;
                    dist_sqrd = (e.x - ptx) * (e.x-ptx) + (e.y-pty) * (e.y-pty);
                    if(dist_sqrd <= ((DOT_RADIUS + 1) * (DOT_RADIUS + 1)))
                    {
                        is_button_down = false;
                        Point newpoint;
                        screen_to_geographic(ptx, pty, out newpoint);
                        track.insert_point(newpoint, counter);
                        idle_redraw();
                        return true;
                    }
                }
                else
                {
                    first_x = cx;
                    first_y = cy;
                }
                counter++;
                last_x = cx;
                last_y = cy;
            }

            if(is_poly)
            {
                int ptx = (last_x+first_x)/2;
                int pty = (last_y+first_y)/2;
                double dist_sqrd = (e.x - ptx) * (e.x-ptx) + (e.y-pty) * (e.y-pty);
                if(dist_sqrd <= ((DOT_RADIUS + 1) * (DOT_RADIUS + 1)))
                {
                    is_button_down = false;
                    Point newpoint;
                    screen_to_geographic(ptx, pty, out newpoint);
                    track.insert_point(newpoint, counter);
                    idle_redraw();
                    return true;
                }
            }
        }

        return false;
    }

    private void download_tile(int zoom, int x, int y, bool redraw = false)
    {
        var dl = new TileDownload();
        dl.redraw = redraw;
        dl.ttl = DOWNLOAD_RETRIES;
        dl.uri = replace_map_uri(repo_uri, zoom, x, y);

        foreach(string uri in tile_queue)
        {
            if(uri == dl.uri)
                return;
        }
        foreach(string uri in missing_tiles)
        {
            if(uri == dl.uri)
                return;
        }
        dl.folder = "%s%c%d%c%d%c".printf(cache_dir, GLib.Path.DIR_SEPARATOR,
                                          zoom, GLib.Path.DIR_SEPARATOR,
                                          x, GLib.Path.DIR_SEPARATOR);
        dl.filename = "%s%c%d%c%d%c%d.%s".printf(
                          cache_dir, GLib.Path.DIR_SEPARATOR,
                          zoom, GLib.Path.DIR_SEPARATOR,
                          x, GLib.Path.DIR_SEPARATOR,
                          y, image_format);

        dl.map = this;
        dl.redraw = redraw;

        var msg = new Soup.Message("GET", dl.uri);
        if(msg != null)
        {
            if(uri_format.is_google == true)
            {
                msg.request_headers.append("Referer", "http://maps.google.com/");

                if(uri_format.has_q)
                {
                    var gc = GLib.Environment.get_variable("GOOGLE_COOKIE");
                    msg.request_headers.append("Cookie", gc);
                }
            }
            tile_queue.append(dl.uri);
            session.queue_message(msg, (session, msg) => {
                bool file_saved = false;
                if(msg.status_code == Soup.Status.OK)
                {
                    //save file
                    try
                    {
                        File file = File.new_for_path(dl.folder);
                        try {
                            file.make_directory_with_parents();
                        }
                        catch(Error e) { }

                        file = File.new_for_path(dl.filename);
                        var file_stream = file.create(FileCreateFlags.REPLACE_DESTINATION);
                        file_stream.write(msg.response_body.data);
                        file_saved = true;

                        if(dl.redraw == true)
                        {
                            CachedTile tile = CachedTile();
                            if(file_saved == true)
                            {
                                tile.pixbuf = new Gdk.Pixbuf.from_file(dl.filename);
                                tile.redraw_cycles = redraw_cycles;
                                tile_cache.insert(dl.filename, tile);
                            }
                            else
                            {
                                string extension = dl.filename.substring(int.max(0, dl.filename.length - 4));
                                var loader = new Gdk.PixbufLoader.with_type(extension);
                                loader.write(msg.response_body.data);
                                loader.close();

                                tile.pixbuf = loader.get_pixbuf();
                                tile.redraw_cycles = redraw_cycles;
                                tile_cache.insert(dl.filename, tile);
                            }

                            idle_redraw();
                        }
                        tile_queue.remove(dl.uri);
                    }
                    catch(Error e)
                    {
                    }
                }
                else
                {
                    if((msg.status_code == Soup.Status.NOT_FOUND)
                            || (msg.status_code == Soup.Status.FORBIDDEN))
                    {
                        missing_tiles.append(dl.uri);
                        tile_queue.remove(dl.uri);
                    }
                    else if(msg.status_code == Soup.Status.CANCELLED)
                        tile_queue.remove(dl.uri);
                    else
                    {
                        dl.ttl--;
                        if(dl.ttl > 0)
                        {
                            session.requeue_message(msg);
                            return;
                        }
                        else
                        {
                            print("Failed to download " + dl.filename + "\n");
                        }
                        tile_queue.remove(dl.uri);
                    }
                }

            });
        }
    }

    private bool find_bigger_tile(out Gdk.Pixbuf pb, out int zoom_found, int zoom, int x, int y)
    {
        int next_zoom, next_x, next_y;

        if (zoom == 0)
            return false;
        next_zoom = zoom - 1;
        next_x = x / 2;
        next_y = y / 2;

        if(load_cached_tile(out pb, next_zoom, next_x, next_y))
            zoom_found = next_zoom;
        else
            return find_bigger_tile(out pb, out zoom_found, next_zoom, next_x, next_y);
        return true;
    }

    private bool load_cached_tile(out Gdk.Pixbuf pb, int zoom, int x, int y)
    {
        string filename = "%s%c%d%c%d%c%d.%s".printf(
                              cache_dir, GLib.Path.DIR_SEPARATOR,
                              zoom, GLib.Path.DIR_SEPARATOR,
                              x, GLib.Path.DIR_SEPARATOR,
                              y, image_format);

        CachedTile? tile = tile_cache.lookup(filename);
        if(tile == null)
        {
            try
            {
                pb = new Gdk.Pixbuf.from_file(filename);
                tile = CachedTile();
                tile.pixbuf = pb;
                tile_cache.insert(filename, tile);
            }
            catch(Error e)
            {
                return false;
            }
        }
        else
        {
            tile.redraw_cycles = redraw_cycles;
            pb = tile.pixbuf;
        }
        return true;
    }

    private bool render_missing_tile_upscaled(out Gdk.Pixbuf pixbuf, int zoom, int x, int y)
    {
        int zoom_big;
        Gdk.Pixbuf big;

        if(find_bigger_tile(out big, out zoom_big, zoom, x, y) == false)
            return false;

        pixbuf = render_tile_upscaled(big, zoom_big, zoom, x, y);
        return true;
    }

    private Gdk.Pixbuf render_tile_upscaled(Gdk.Pixbuf big, int zoom_big, int zoom, int x, int y)
    {
        int zoom_diff = zoom-zoom_big;
        int area_size = TILESIZE >> zoom_diff;
        int modulo = 1 << zoom_diff;
        int area_x = (x % modulo) * area_size;
        int area_y = (y % modulo) * area_size;

        var area = new Gdk.Pixbuf.subpixbuf(big, area_x, area_y, area_size, area_size);
        return area.scale_simple(TILESIZE, TILESIZE, Gdk.InterpType.BILINEAR);
    }

    private bool render_missing_tile(out Gdk.Pixbuf ret, int zoom, int x, int y)
    {
        bool rt = render_missing_tile_upscaled(out ret, zoom, x, y);
        return rt;
    }

    private void blit_tile(Gdk.Pixbuf pixbuf, Cairo.Context cr,
                           int offset_x, int offset_y,
                           int tile_zoom, int target_x, int target_y)
    {
        if(tile_zoom == map_zoom)
        {
            Gdk.cairo_set_source_pixbuf(cr, pixbuf, offset_x+drag_mouse_dx, offset_y+drag_mouse_dy);
            cr.paint();
        }
        else
        {
            var pixbuf_scaled = render_tile_upscaled(pixbuf, tile_zoom, map_zoom, target_x, target_y);
            blit_tile(pixbuf_scaled, cr, offset_x, offset_y, map_zoom, target_x, target_y);
        }
    }

    private void load_tile(Cairo.Context cr, int zoom, int x, int y, int offset_x, int offset_y)
    {
        string filename = "%s%c%d%c%d%c%d.%s".printf(
                              cache_dir, GLib.Path.DIR_SEPARATOR,
                              zoom, GLib.Path.DIR_SEPARATOR,
                              x, GLib.Path.DIR_SEPARATOR,
                              y, image_format);
        Gdk.Pixbuf pixbuf;
        try
        {
            if(load_cached_tile(out pixbuf, zoom, x, y) == false)
                pixbuf = new Gdk.Pixbuf.from_file(filename);
            blit_tile(pixbuf, cr, offset_x, offset_y, zoom, x, y);
        }
        catch(Error e)
        {
            download_tile(zoom, x, y, true);
            if(render_missing_tile(out pixbuf, zoom, x, y) == true)
                blit_tile(pixbuf, cr, offset_x, offset_y, zoom, x, y);
            else
                draw_blank_tile(cr, offset_x, offset_y);
        }
    }

    private void draw_tiles(Cairo.Context cr)
    {
        Gtk.Allocation allocation;
        get_allocation(out allocation);

        int offset_x = -map_x%TILESIZE;
        int offset_y = -map_y%TILESIZE;
        if(offset_x > 0)
            offset_x -= TILESIZE;
        if(offset_y > 0)
            offset_y -= TILESIZE;

        int offset_yn = offset_y;

        int tiles_nx = (allocation.width  - offset_x) / TILESIZE + 1;
        int tiles_ny = (allocation.height - offset_y) / TILESIZE + 1;

        int tile_x0 = (int)Math.floor((float)map_x / (float)TILESIZE);
        int tile_y0 = (int)Math.floor((float)map_y / (float)TILESIZE);

        for(int i = tile_x0; i <(tile_x0+tiles_nx); i++)
        {
            for(int j = tile_y0; j < (tile_y0+tiles_ny); j++)
            {
                if( j<0 || i<0 || i>=Math.exp(map_zoom * Math.LN2) || j>=Math.exp(map_zoom * Math.LN2))
                    draw_blank_tile(cr, offset_x, offset_yn); //outside map region
                else
                    load_tile(cr, map_zoom, i, j, offset_x, offset_yn);

                offset_yn += TILESIZE;
            }
            offset_x += TILESIZE;
            offset_yn = offset_y;
        }
    }

    private void draw_track(Cairo.Context cr, Track track, bool is_poly)
    {
        cr.set_source_rgba(track.color.red, track.color.green, track.color.blue, track.color.alpha);
        cr.set_line_width(track.line_width);
        int last_x = 0;
        int last_y = 0;
        int first_x = 0;
        int first_y = 0;
        int count = 0;
        foreach(var point in track.points)
        {
            int x = 0;
            int y = 0;
            geographic_to_screen(point, out x, out y);
            if(count == 0)
            {
                cr.move_to(x, y);
                first_x = x;
                first_y = y;
            }
            else
            {
                cr.line_to(x, y);
                cr.stroke();
            }

            if(track.editable == true)
            {
                cr.arc (x, y, DOT_RADIUS, 0.0, 2.0 * Math.PI);
                cr.fill();
                if(count > 0)
                {
                    cr.set_source_rgba(track.color.red, track.color.green, track.color.blue, (double)track.color.alpha*0.7);
                    cr.arc((last_x + x)/2.0, (last_y+y)/2.0, DOT_RADIUS, 0.0, 2.0*Math.PI);
                    cr.fill();
                    cr.set_source_rgba(track.color.red, track.color.green, track.color.blue, track.color.alpha);
                }
            }

            cr.move_to(x, y);

            last_x = x;
            last_y = y;
            count++;
        }
        if(is_poly)
        {
            cr.line_to(first_x, first_y);
            cr.stroke();
        }
    }

    private void draw_tracks(Cairo.Context cr)
    {
        cr.set_line_cap(Cairo.LineCap.ROUND);
        cr.set_line_join (Cairo.LineJoin.ROUND);
        foreach(var track in tracks)
        {
            draw_track(cr, track, false);
        }
    }

    private void draw_images(Cairo.Context cr)
    {
        foreach(var image in images)
        {
            var rect = Gdk.Rectangle();
            var pt = image.point;
            rect.x = lon2pixel(map_zoom, pt.rlon) - map_x + drag_mouse_dx;
            rect.y = lat2pixel(map_zoom, pt.rlat) - map_y + drag_mouse_dy;
            image.draw(cr, rect);
        }
    }

    private void draw_polygons(Cairo.Context cr)
    {
        foreach(var poly in polygons)
        {
            cr.set_source_rgba(poly.fill_color.red, poly.fill_color.green, poly.fill_color.blue, poly.fill_color.alpha);

            int first_x = 0;
            int first_y = 0;
            int last_x = 0;
            int last_y = 0;
            int count = 0;
            foreach(var point in poly.points)
            {
                int x = 0;
                int y = 0;
                geographic_to_screen(point, out x, out y);
                if(count == 0)
                {
                    cr.move_to(x, y);
                    first_x = x;
                    first_y = y;
                }
                else
                    cr.line_to(x, y);

                last_x = x;
                last_y = y;
                count++;
            }

            cr.line_to(first_x, first_y);
            cr.fill();

            draw_track(cr, poly, true);

            cr.set_source_rgba(poly.color.red, poly.color.green, poly.color.blue, (double)poly.color.alpha*0.7);
            cr.arc((last_x + first_x)/2.0, (last_y+first_y)/2.0, DOT_RADIUS, 0.0, 2.0*Math.PI);
            cr.fill();
        }
    }

    public override bool draw(Cairo.Context cr)
    {
        redraw_cycles++;
        draw_tiles(cr);
        draw_images(cr);
        draw_polygons(cr);
        draw_tracks(cr);

        Gtk.Allocation allocation;
        get_allocation(out allocation);
        if(show_zoom_control == true)
            zoom_control.draw(cr, allocation.width, allocation.height);

        redraw_flag = true;
        return true;
    }

    private void draw_blank_tile(Cairo.Context cr, int offset_x, int offset_y)
    {
        cr.save();
        cr.set_source_rgb(1.0, 1.0, 1.0);
        cr.rectangle(offset_x, offset_y, TILESIZE, TILESIZE);
        cr.fill();
        cr.restore();
    }

    private string replace_map_uri(string uri, int zoom, int x, int y)
    {
        string url = uri;
        if(uri_format.has_x)
            url = replace_first(url, URI_MARKER_X, x.to_string());
        if(uri_format.has_y)
            url = replace_first(url, URI_MARKER_Y, y.to_string());
        if(uri_format.has_z)
            url = replace_first(url, URI_MARKER_Z, zoom.to_string());
        if(uri_format.has_s)
            url = replace_first(url, URI_MARKER_S, (zoom_max-zoom).to_string());
        ///TODO quad tree isn't needed for our map sources, but for 100% OsmGpsMap
        //compatibility it should be included one day
        if(uri_format.has_r)
            url = replace_first(url, URI_MARKER_R, GLib.Random.int_range(0, 4).to_string());
        return url;
    }

    private string replace_first(string text, string search, string replace)
    {
        int pos = text.index_of(search);
        if (pos < 0)
            return text;
        return text.substring(0, pos) + replace + text.substring(pos + search.length);
    }

    private void screen_to_geographic(int x, int y, out Point point)
    {
        point = new Point.radians(pixel2lat(map_zoom, map_y + y),
                                pixel2lon(map_zoom, map_x + x));
    }

    private void geographic_to_screen(Point pt, out int x, out int y)
    {
        x = lon2pixel(map_zoom, pt.rlon) - map_x + drag_mouse_dx;
        y = lat2pixel(map_zoom, pt.rlat) - map_y + drag_mouse_dy;
    }

    private int lat2pixel(int zoom, double lat)
    {
        double lat_m;
        int pixel_y;

        lat_m = Math.atanh(Math.sin(lat));

        /* the formula is
         *
         * some more notes
         * http://manialabs.wordpress.com/2013/01/26/converting-latitude-and-longitude-to-map-tile-in-mercator-projection/
         *
         * pixel_y = -(2^zoom * TILESIZE * lat_m) / 2PI + (2^zoom * TILESIZE) / 2
         */
        pixel_y = -(int)( (lat_m * TILESIZE * (1 << zoom) ) / (2*Math.PI)) +
                  ((1 << zoom) * (TILESIZE/2) );

        return pixel_y;
    }

    private int lon2pixel(int zoom, double lon)
    {
        int pixel_x;

        /* the formula is
         *
         * pixel_x = (2^zoom * TILESIZE * lon) / 2PI + (2^zoom * TILESIZE) / 2
         */
        pixel_x = (int)(( lon * TILESIZE * (1 << zoom) ) / (2*Math.PI)) +
                  ( (1 << zoom) * (TILESIZE/2) );
        return pixel_x;
    }

    private double pixel2lon(double zoom, int pixel_x)
    {
        double lon;

        lon = ((pixel_x - (Math.exp(zoom * Math.LN2) * (TILESIZE/2) ) ) *2*Math.PI) /
              (TILESIZE * Math.exp(zoom * Math.LN2) );

        return lon;
    }

    private double pixel2lat(double zoom, int pixel_y)
    {
        double lat, lat_m;

        lat_m = (-( pixel_y - (Math.exp(zoom * Math.LN2) * (TILESIZE/2) ) ) * (2*Math.PI)) /
                (TILESIZE * Math.exp(zoom * Math.LN2));

        lat = Math.asin(Math.tanh(lat_m));

        return lat;
    }

    private int latlon2zoom(int pix_height, int pix_width, double lat1, double lat2, double lon1, double lon2)
    {
        double lat1_m = Math.atanh(Math.sin(lat1));
        double lat2_m = Math.atanh(Math.sin(lat2));
        int zoom_lon = (int)Math.log2((double)(2 * pix_width * Math.PI) / ((double)TILESIZE * (lon2 - lon1)));
        int zoom_lat = (int)Math.log2((double)(2 * pix_height * Math.PI) / ((double)TILESIZE * (lat2_m - lat1_m)));
        return int.min(zoom_lon, zoom_lat);
    }

    private void update_center_coord()
    {
        Gtk.Allocation allocation;
        get_allocation(out allocation);

        int pixel_x = map_x + allocation.width/2;
        int pixel_y = map_y + allocation.height/2;

        center_rlon = pixel2lon(map_zoom, pixel_x);
        center_rlat = pixel2lat(map_zoom, pixel_y);
    }

    public string cache_dir { get; set; }
    public bool scroll_wheel { get; set; }
    public bool show_zoom_control { get; set; }

    private Source map_source;

    private GLib.SList<string> tile_queue;
    private GLib.SList<string> missing_tiles;
    private GLib.HashTable<string, CachedTile?> tile_cache;

    private GLib.SList<Track> tracks;
    private GLib.SList<Image> images;
    private GLib.SList<Polygon> polygons;
    private GLib.SList<Layer> layers;

    private Track drag_track;
    private Point drag_point;

    private Soup.Session session;

    private string image_format;
    private string repo_uri;
    private UriFormat uri_format;

    private int zoom_min;
    private int zoom_max;
    private int map_zoom;

    private int map_x;
    private int map_y;

    private int drag_start_x;
    private int drag_start_y;
    private int drag_mouse_dx;
    private int drag_mouse_dy;

    private double center_rlon;
    private double center_rlat;

    private const int TILESIZE = 256;
    private const int MAX_DOWNLOAD_TILES = 25000;
    private const int DOWNLOAD_RETRIES = 10;
    private const double DOT_RADIUS = 4.0;

    private uint redraw_cycles;

    private bool redraw_flag;
    private bool is_button_down;
    private bool is_dragging_point;

    private ZoomControl zoom_control;
}

private class TileDownload: Object
{
    public TileDownload()
    {
        uri = "";
        folder = "";
        filename = "";
        redraw = true;
        ttl = 0;
    }

    public string uri { get; set; }
    public string folder { get; set; }
    public string filename { get; set; }
    public bool redraw { get; set; }
    public int ttl { get; set; }
    public Map map { get; set; }
}

private struct CachedTile
{
    public Gdk.Pixbuf pixbuf { get; set; }
    public uint redraw_cycles { get; set; }
}


}

/*
    Copyright (C) 2021 Samuel Cowen <samuel.cowen@camelsoftware.com>

    This file is part of mapness.

    mapness is free software: you can redistribute it and/or modify
    it under the terms of the Lesser GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    mapness is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    Lesser GNU General Public License for more details.

    You should have received a copy of the Lesser GNU General Public License
    along with mapness.  If not, see <http://www.gnu.org/licenses/>.
*/

using Gtk;
using Gee;

namespace mapness
{

/**
 * A track represents a pathway, or a series of points across the map.
 * Tracks can be drawn in different colours and with different line widths.
 * They can be 'editable', so users can click to insert or change points.
 * There are signals for the points on the track being addded, inserted, changed
 * and removed.
 *
 * Tracks can also store generic values called properties, not to be confused 
 * with normal object properties. They are key-value pairs stored with the object.
 * It's just to store extra data with your track.
 */

public class Track: Object
{
    /**************************************************************************
    ***************************************************************************
    ________  ___  ___  ________  ___       ___  ________
    |\   __  \|\  \|\  \|\   __  \|\  \     |\  \|\   ____\
    \ \  \|\  \ \  \\\  \ \  \|\ /\ \  \    \ \  \ \  \___|
    \ \   ____\ \  \\\  \ \   __  \ \  \    \ \  \ \  \
     \ \  \___|\ \  \\\  \ \  \|\  \ \  \____\ \  \ \  \____
      \ \__\    \ \_______\ \_______\ \_______\ \__\ \_______\
       \|__|     \|_______|\|_______|\|_______|\|__|\|_______|

    ***************************************************************************
    **************************************************************************/

    public Track()
    {
        points = new GLib.SList<Point>();
        color = new Gdk.RGBA();
        map = new HashMap<string, Value?>();
        color.parse("rgba(255, 0, 0, 0.9)");
        editable = false;
        line_width = 2;
        breakable = true;
    }

    /**
     * Adds a point to the end of the track.
     * Emits a 'point_added' signal.
     */
    public void add_point(Point p)
    {
        points.append(p);
        point_added();
    }

    /**
     * Removes a point from a given position along the track.
     * ie. remove_point(3) would remove the third point from
     * the start of the track.
     * Emits a 'point_removed' signal.
     */
    public void remove_point(uint pos)
    {
        var p = points.nth_data(pos);
        points.remove(p);
        point_removed(pos);
    }

/**
 * Adds a generic key/value to the point
 */
    public void add_property(string name, Value? v) 
    {
        map.set(name, v);
    }

/**
 * true if the point has a property of this name
 */
    public bool has_property(string name) 
    {
        return name in map;
    }

/**
 * Gets a value by key
 */
    public Value? get_property(string name)
    {
        return map.get(name);
    }

/**
 * Removes a property
 */
    public void remove_property(string name) 
    {
        if(name in map)
        {
            map.unset(name);
        }
    }

    /**
     * Returns the number of points in the track.
     */
    public uint n_points()
    {
        return points.length();
    }

    /**
     * Inserts a point into the track as position 'pos'.
     * Emits a 'point_inserted' signal.
     */
    public void insert_point(Point p, int pos)
    {
        points.insert(p, pos);
        point_inserted(pos);
    }

    /**
     * Gets a point from a position.
     */
    public Point get_point(uint pos)
    {
        return points.nth_data(pos);
    }

    /**
     * Returns the length of the track in meters.
     */
    public double get_length()
    {
        double ret = 0;

        if(n_points() < 2)
            return ret;


        uint count = 0;
        var point_b = new Point.degrees(0, 0);
        var point_a = new Point.degrees(0, 0);

        foreach(var p in points)
        {
            point_a = point_b;
            point_b = p;

            if(count >= 1)
            {
                ret += Math.acos(Math.sin(point_a.rlat)*Math.sin(point_b.rlat)
                    + Math.cos(point_a.rlat)*Math.cos(point_b.rlat)*Math.cos(point_b.rlon-point_a.rlon)) * 6371109; //the mean raduis of earth
            }
            count++;
        }

        return ret;
    }

    /**
     * Sets the colour and alpha (transparency) of the track.
     * All values should be between 0 and 1.0. Zero is black/transparent.
     * 1.0 is white/not transparent.
     */
    public void set_color(double r, double g, double b, double a)
    {
        color.red = r;
        color.blue = b;
        color.green = g;
        color.alpha = a;
    }

    /**
     * Gets the RGBA values for the track color.
     */
    public void get_color(out double r, out double g, out double b, out double a)
    {
        r = color.red;
        g = color.green;
        b = color.blue;
        a = color.alpha;
    }

    /**
     * The point added signal is emited whenever a point is appended to the
     * end of the track.
     */
    public signal void point_added();

    /**
     * The point inserted signal is emited whenever a point is inserted into
     * the track.
     */
    public signal void point_inserted(uint n);

    /**
     * The point removed signal is emited whenever a point is removed from the
     * track.
     */
    public signal void point_removed(uint pos);

    /**
     * The point changed signal is emited whenever a point is changed by the
     * user. Only editable tracks will emit this signal - because users can only
     * change editable tracks.
     */
    public signal void point_changed(Point pt);

    /**
     * This is the list of points.
     * Changing this directly will not emit any signals.
     */
    public unowned GLib.SList<Point> points { get; set; }

    /**
     * The Gdk.RGBA colour of the track.
     */
    public Gdk.RGBA color;

    /**
     * If true, the user will be able to insert points and move them around
     * using the mouse.
     */
    public bool editable { get; set; }

    /**
     * The width of the track. Default is 2.
     */
    public uint line_width { get; set; }

    /**
     * If breakable is set to false, users will not be able to insert points
     * into an editable track.
     * Default value is true.
     */
    public bool breakable { get; set; }

    /**
     * A name for your track
     */
    public string name { get; set; }

    private HashMap<string, Value?> map;

}

}

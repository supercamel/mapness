API Overview
============

Mapness is a GObject library. The Vala package is ``mapness-2.0`` and GI
consumers import namespace ``mapness`` version ``2.0``.

Map
---

``mapness.Map`` is a ``Gtk.DrawingArea`` subclass and the main widget.

Common methods:

* ``set_map_source(MapSource source)`` switches to a built-in source.
* ``set_source(Source source)`` switches to a custom source object.
* ``set_center(Point point)`` sets the geographic center.
* ``set_zoom(int zoom)`` sets the zoom level.
* ``set_center_and_zoom(Point point, int zoom)`` sets both together.
* ``get_center()`` returns the current center as a ``Point``.
* ``get_zoom()`` returns the current zoom level.
* ``get_bounds(out Point top_left, out Point lower_right)`` returns visible bounds.
* ``get_zoom_for_bounds(Point a, Point b)`` finds a zoom that fits two points.
* ``screen_to_geographic(int x, int y, out Point point)`` converts widget pixels.
* ``geographic_to_screen(Point point, out int x, out int y)`` converts map points.

Overlay methods:

* ``add_image(Image image)`` and ``remove_image(Image image)``
* ``add_track(Track track)`` and ``remove_track(Track track)``
* ``add_polygon(Polygon polygon)`` and ``remove_polygon(Polygon polygon)``
* ``add_layer(Layer layer)`` and ``remove_layer(Layer layer)``

Useful properties:

* ``cache_dir``
* ``scroll_wheel``
* ``show_zoom_control``
* ``min_zoom``
* ``max_zoom``

Point
-----

``Point`` stores latitude and longitude in radians and offers convenience
constructors for degrees:

* ``Point.degrees(double lat, double lon)``
* ``Point.radians(double lat, double lon)``
* ``set_degrees(double lat, double lon)``
* ``get_lat()`` and ``get_lon()``
* ``rlat`` and ``rlon``

Source And MapSource
--------------------

``MapSource`` contains the built-in tile sources:

* ``OPENSTREETMAP``
* ``GOOGLESTREET``
* ``GOOGLESATELLITE``
* ``GOOGLEHYBRID``
* ``OSM_CUSTOM``

``Source.custom(string uri)`` accepts OpenStreetMap-style URL templates.

Image
-----

``Image`` draws a ``Gdk.Pixbuf`` anchored to a map point.

* ``Image(Gdk.Pixbuf pixbuf)``
* ``Image.from_file(string path, Point point)``
* ``point``
* ``rotation``

Track
-----

``Track`` draws a sequence of points and can be made editable.

Core methods:

* ``add_point(Point point)``
* ``insert_point(Point point, int position)``
* ``remove_point(uint position)``
* ``get_point(uint position)``
* ``n_points()``
* ``get_length()``
* ``set_color(double r, double g, double b, double a)``
* ``get_color(out double r, out double g, out double b, out double a)``

Signals:

* ``point_clicked(uint n)``
* ``point_added()``
* ``point_inserted(uint n)``
* ``point_removed(uint position)``
* ``point_changed(Point point)``

Polygon
-------

``Polygon`` extends ``Track`` and closes the path.

* ``set_fill_color(double r, double g, double b, double a)``
* ``get_fill_color(out double r, out double g, out double b, out double a)``
* ``fill_center``

Layer
-----

``Layer`` is an interface for custom Cairo overlays and pointer handling.

Implement:

* ``draw(Cairo.Context cr, int width, int height)``
* ``on_click(PointerEvent event)``
* ``on_motion(PointerEvent event)``

``PointerEvent`` carries ``x``, ``y``, ``button``, ``n_press``, and modifier
``state``.

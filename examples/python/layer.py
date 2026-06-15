#!/usr/bin/python3

import gi
import sys

gi.require_version('Gtk', '4.0')
gi.require_version('mapness', '2.0')
from gi.repository import GObject
from gi.repository import Gtk
from gi.repository import mapness
import cairo


class MyLayer(GObject.GObject, mapness.Layer):
    def __init__(self):
        GObject.GObject.__init__(self)

    def do_draw(self, cr, width, height):
        cr.set_source_rgba(0.0, 0.5, 0.5, 0.4)
        cr.rectangle(100, 100, width-200, height-200)
        cr.fill()

    def do_on_motion(self, event):
        print("Motion notify", event.x, event.y)
        return False

    def do_on_click(self, event):
        print("on click", event.x, event.y, event.button)
        return False

class MapWindow(Gtk.Application):
    """ """

    def __init__(self):
        super().__init__(application_id="org.mapness.LayerExample")

    def on_point_changed(self, track, point):
        meters = self.track.get_length()
        print("Length: " + str(meters) + "m")

    def do_activate(self):
        self.win = Gtk.ApplicationWindow(application=self)
        self.win.set_default_size(800, 600)
        self.win.set_title("Rule The World")


        self.map = mapness.Map.new()
        self.map.set_map_source(mapness.MapSource.OPENSTREETMAP)

        self.layer = MyLayer()

        self.map.add_layer(self.layer)

        self.win.set_child(self.map)
        self.win.present()
        self.map.set_center_and_zoom(mapness.Point.degrees(0, 0), 4)


mapwin = MapWindow()
mapwin.run(sys.argv)

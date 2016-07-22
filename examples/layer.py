#!/usr/bin/python3

import gi
gi.require_version('Gtk', '3.0')
gi.require_version('mapness', '0.1')
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

    def do_on_motion(self, e):
        print("Motion notify")
        return False

    def do_on_click(self, e):
        print("on click")
        return False

class MapWindow:
    """ """

    def on_point_changed(self, track, point):
        meters = self.track.get_length()
        print("Length: " + str(meters) + "m")

    def begin(self):

        self.win = Gtk.Window()
        self.win.connect("delete-event", Gtk.main_quit)
        self.win.set_default_size(800, 600)
        self.win.set_title("Rule The World")


        self.map = mapness.Map.new()
        self.map.set_source(mapness.Source.GOOGLESATELLITE)

        self.layer = MyLayer()

        self.map.add_layer(self.layer)

        self.win.add(self.map)
        self.win.show_all()
        self.map.set_center_and_zoom(mapness.Point.degrees(0, 0), 4)
        Gtk.main()


mapwin = MapWindow()
mapwin.begin()

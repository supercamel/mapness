#!/usr/bin/python3

import gi
import sys

gi.require_version('Gtk', '4.0')
gi.require_version('mapness', '2.0')
from gi.repository import Gtk
from gi.repository import mapness


class Ruler(Gtk.Application):
    """ """

    def __init__(self):
        super().__init__(application_id="org.mapness.MeasureExample")

    def on_point_changed(self, track, point):
        meters = self.track.get_length()
        print("Length: " + str(meters) + "m")

    def do_activate(self):
        self.win = Gtk.ApplicationWindow(application=self)
        self.win.set_default_size(800, 600)
        self.win.set_title("Rule The World")

        self.map = mapness.Map.new()
        self.map.set_map_source(mapness.MapSource.OPENSTREETMAP)

        self.track = mapness.Track.new()
        self.track.set_color(1.0, 0.0, 0.0, 0.8)
        self.track.set_editable(True)
        self.track.set_breakable(False)

        p1 = mapness.Point.degrees(-5.0, 0)
        p2 = mapness.Point.degrees(5.0, 0)
        self.track.add_point(p1)
        self.track.add_point(p2)
        self.track.set_line_width(10)

        self.track.connect("point-changed", self.on_point_changed)

        self.map.add_track(self.track)

        self.win.set_child(self.map)
        self.win.present()
        self.map.set_center_and_zoom(mapness.Point.degrees(0, 0), 4)


ruler = Ruler()
ruler.run(sys.argv)

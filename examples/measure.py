#!/usr/bin/python3

import gi
gi.require_version('Gtk', '3.0')
gi.require_version('mapness', '0.1')
from gi.repository import Gtk
from gi.repository import mapness


class Ruler:
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

        self.track = mapness.Track.new()
        self.track.set_color(1.0, 0.0, 0.0, 0.8)
        self.track.set_editable(True)
        self.track.set_breakable(False)

        self.track.add_property("test", 100.0)

        print(self.track.get_property("test"))


        p1 = mapness.Point.degrees(-5.0, 0)
        p2 = mapness.Point.degrees(5.0, 0)
        self.track.add_point(p1)
        self.track.add_point(p2)
        self.track.set_line_width(10.0)

        self.track.connect("point_changed", self.on_point_changed)

        self.map.add_track(self.track)

        self.win.add(self.map)
        self.win.show_all()
        self.map.set_center_and_zoom(mapness.Point.degrees(0, 0), 4)

        Gtk.main()


ruler = Ruler()
ruler.begin()

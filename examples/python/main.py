#!/usr/bin/python3

import gi
import sys
from pathlib import Path

gi.require_version('Gtk', '4.0')
gi.require_version('mapness', '2.0')
from gi.repository import Gtk
from gi.repository import mapness


class Demo(Gtk.Application):
    def __init__(self):
        super().__init__(application_id="org.mapness.MainExample")

    def do_activate(self):
        win = Gtk.ApplicationWindow(application=self)
        win.set_default_size(800, 600)
        win.set_title("Welcome to mapness")

        map_widget = mapness.Map.new()
        map_widget.set_map_source(mapness.MapSource.OPENSTREETMAP)

        melb = mapness.Point.degrees(-37.8136, 144.9631)
        image_path = Path(__file__).resolve().parents[2] / "test.png"
        map_widget.add_image(mapness.Image.from_file(str(image_path), melb))

        win.set_child(map_widget)
        win.present()
        map_widget.set_center_and_zoom(melb, 8)


Demo().run(sys.argv)

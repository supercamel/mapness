#!/usr/bin/python3

import gi
gi.require_version('Gtk', '3.0')
gi.require_version('mapness', '0.1')
from gi.repository import Gtk
from gi.repository import mapness

win = Gtk.Window()
win.connect("delete-event", Gtk.main_quit)
win.set_default_size(800, 600)
win.set_title("Welcome to mapness")

map = mapness.Map.new()
map.set_source(mapness.Source.OPENSTREETMAP)

melb = mapness.Point.degrees(-37.8136, 144.9631)
map.add_image(mapness.Image.from_file("test.png", melb))
win.add(map)
win.show_all()
map.set_center_and_zoom(melb, 8)

Gtk.main()

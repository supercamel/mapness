#!/usr/bin/gjs

const GLib = imports.gi.GLib;
const Gtk = imports.gi.Gtk;
const Lang = imports.lang;
const mapness = imports.gi.mapness;

const MapnessTest= new Lang.Class ({
    Name: 'Mapness Test',

    _init: function () {
        this.application = new Gtk.Application ();

        this.application.connect('activate', Lang.bind(this, this._onActivate));
        this.application.connect('startup', Lang.bind(this, this._onStartup));
    },

    _onActivate: function () {
        this._window.present ();
    },

    _onStartup: function () {
        this._buildUI ();
    },

    _buildUI: function () {
        this._window = new Gtk.ApplicationWindow  ({
            application: this.application,
            title: "Welcome to mapness",
            default_height: 600,
            default_width: 800,
            window_position: Gtk.WindowPosition.CENTER });

        this.map = mapness.Map.new();
        this.map.set_source(mapness.Source.VIRTUALEARTHSATELLITE);

        var melb = mapness.Point.degrees(-37.8136, 144.9631);
        this.map.add_image(mapness.Image.from_file("test.png",
                            melb));

        this._window.add (this.map);
        this._window.show_all();

        this.map.set_center_and_zoom(melb, 8);
    },

});

let app = new MapnessTest();
app.application.run (ARGV);

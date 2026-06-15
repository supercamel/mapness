#!/usr/bin/gjs

imports.gi.versions.Gtk = '4.0';
imports.gi.versions.mapness = '2.0';

const GLib = imports.gi.GLib;
const Gtk = imports.gi.Gtk;
const System = imports.system;
const mapness = imports.gi.mapness;

const scriptDir = System.programPath
    ? GLib.path_get_dirname(System.programPath)
    : GLib.get_current_dir();
const projectRoot = GLib.build_filenamev([scriptDir, '..', '..']);
const markerPath = GLib.build_filenamev([projectRoot, 'test.png']);

let app = new Gtk.Application({ application_id: 'org.mapness.GjsExample' });

app.connect('activate', () => {
    let map = mapness.Map.new();
    map.set_map_source(mapness.MapSource.OPENSTREETMAP);

    let melb = mapness.Point.degrees(-37.8136, 144.9631);
    map.add_image(mapness.Image.from_file(markerPath, melb));
    map.set_center_and_zoom(melb, 8);

    let window = new Gtk.ApplicationWindow({
        application: app,
        title: 'Welcome to mapness',
        default_height: 600,
        default_width: 800
    });

    window.set_child(map);
    window.present();
});

app.run(ARGV);

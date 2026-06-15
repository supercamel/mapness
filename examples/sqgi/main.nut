/**
 * examples/sqgi/main.nut
 *
 * Basic mapness + SQGI + GTK4 example.
 *
 * Usage:
 *   sqgi main.nut
 *   sqgi main.nut --timeout=5
 */

local Gtk = import("Gtk", "4.0")
local Pb = import("GdkPixbuf")
local Mapness = import("mapness", "2.0")

local hard_timeout = 0
foreach (a in vargv) {
    if (a.find("--timeout=") == 0) hard_timeout = a.slice(10).tointeger()
}

function make_marker_pixbuf() {
    local pb = Pb.Pixbuf.new(Pb.Colorspace.rgb, true, 8, 28, 28)
    pb.fill(0xE84D5BFF)

    local inner = Pb.Pixbuf.new(Pb.Colorspace.rgb, true, 8, 14, 14)
    inner.fill(0xFFFFFFFF)
    inner.composite(pb, 7, 7, 14, 14, 7, 7, 1.0, 1.0, Pb.InterpType.nearest, 255)
    return pb
}

local app = Gtk.Application.new("org.mapness.sqgi.main", 0)

app.connect("activate", function() {
    local map = Mapness.Map.new()
    map.set_map_source(Mapness.MapSource.openstreetmap)

    local melbourne = Mapness.Point.degrees(-37.8136, 144.9631)
    local marker = Mapness.Image.new(make_marker_pixbuf())
    marker.set_point(melbourne)
    map.add_image(marker)
    map.set_center_and_zoom(melbourne, 8)

    local win = Gtk.ApplicationWindow.new(app)
    win.set_title("mapness SQGI")
    win.set_default_size(800, 600)
    win.set_child(map)
    win.present()

    if (hard_timeout > 0) {
        sqgi.timeout_add(hard_timeout * 1000, function() {
            win.close()
            return false
        })
    }
})

local status = app.run(0, null)
print("Application exited with status " + status + "\n")

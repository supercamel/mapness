/**
 * examples/sqgi/polygon.nut
 *
 * Polygon overlay example for mapness via SQGI.
 *
 * Usage:
 *   sqgi polygon.nut
 *   sqgi polygon.nut --timeout=5
 */

local Gtk = import("Gtk", "4.0")
local Mapness = import("mapness", "2.0")

local hard_timeout = 0
foreach (a in vargv) {
    if (a.find("--timeout=") == 0) hard_timeout = a.slice(10).tointeger()
}

local app = Gtk.Application.new("org.mapness.sqgi.polygon", 0)

app.connect("activate", function() {
    local map = Mapness.Map.new()
    map.set_map_source(Mapness.MapSource.openstreetmap)

    local poly = Mapness.Polygon.new()
    poly.set_color(0.06, 0.24, 0.70, 0.95)
    poly.set_fill_color(0.15, 0.62, 0.42, 0.28)
    poly.set_line_width(4)
    poly.set_editable(true)

    poly.add_point(Mapness.Point.degrees(-38.45, 144.20))
    poly.add_point(Mapness.Point.degrees(-37.45, 144.45))
    poly.add_point(Mapness.Point.degrees(-37.70, 145.55))
    poly.add_point(Mapness.Point.degrees(-38.35, 145.20))

    map.add_polygon(poly)
    map.set_center_and_zoom(Mapness.Point.degrees(-37.95, 144.95), 8)

    local win = Gtk.ApplicationWindow.new(app)
    win.set_title("mapness SQGI polygon")
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

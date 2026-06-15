/**
 * examples/sqgi/measure.nut
 *
 * Editable track example for mapness via SQGI.
 *
 * Usage:
 *   sqgi measure.nut
 *   sqgi measure.nut --timeout=5
 */

local Gtk = import("Gtk", "4.0")
local Mapness = import("mapness", "2.0")

local hard_timeout = 0
foreach (a in vargv) {
    if (a.find("--timeout=") == 0) hard_timeout = a.slice(10).tointeger()
}

local app = Gtk.Application.new("org.mapness.sqgi.measure", 0)

app.connect("activate", function() {
    local map = Mapness.Map.new()
    map.set_map_source(Mapness.MapSource.openstreetmap)

    local track = Mapness.Track.new()
    track.set_color(0.95, 0.12, 0.18, 0.85)
    track.set_line_width(5)
    track.set_editable(true)
    track.set_breakable(false)
    track.set_name("equator")

    track.add_point(Mapness.Point.degrees(-5.0, 0.0))
    track.add_point(Mapness.Point.degrees(5.0, 0.0))

    track.connect("point-changed", function(self, point) {
        print("Track length: " + self.get_length() + "m\n")
    })

    map.add_track(track)
    map.set_center_and_zoom(Mapness.Point.degrees(0.0, 0.0), 4)

    local win = Gtk.ApplicationWindow.new(app)
    win.set_title("mapness SQGI measure")
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

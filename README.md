#Mapness

Mapness is a Gtk+ map widget with a focus on being roughly equivalent to
Google Maps.

Mapness can source maps from Open street maps, Google Maps and Virtual Earth.


Mapness has been inspired by the OsmGpsMap, but unlike OsmGpsMap it is written
 in the Vala programming language. 

Please see https://github.com/nzjrs/osm-gps-map
for the list of OsmGpsMap authors.

It's easy to generate bindings of Mapness for other languages.

This project uses the Meson build system.

    meson builddir
    ninja -C builddir
    cd builddir && meson install


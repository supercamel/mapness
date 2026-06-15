# Mapness

Mapness is a GTK4 map widget with a focus on being roughly equivalent to a
small embeddable Google Maps-style widget.

Mapness can source maps from OpenStreetMap, Google Maps, and custom
OpenStreetMap-style tile servers.


Mapness has been inspired by OsmGpsMap, but unlike OsmGpsMap it is written in
the Vala programming language.

Please see https://github.com/nzjrs/osm-gps-map
for the list of OsmGpsMap authors.

It's easy to generate bindings of Mapness for other languages.

This project uses GTK4, libsoup3, and the Meson build system.

    meson setup builddir
    ninja -C builddir
    cd builddir && meson install

The introspection namespace is `mapness` with version `2.0`; the VAPI and
pkg-config package are `mapness-2.0`.

After installing mapness, examples can be run from their language folders:

    cd examples/python && python3 main.py
    cd examples/gjs && gjs main.js
    cd examples/sqgi && sqgi main.nut
    cd examples/vala && valac --pkg gtk4 --pkg mapness-2.0 main.vala -o mapness-vala-example && ./mapness-vala-example

For an uninstalled development build, run from the project root with:

    GI_TYPELIB_PATH=builddir LD_LIBRARY_PATH=builddir python3 examples/python/main.py
    GI_TYPELIB_PATH=builddir LD_LIBRARY_PATH=builddir gjs examples/gjs/main.js
    GI_TYPELIB_PATH=builddir LD_LIBRARY_PATH=builddir sqgi examples/sqgi/main.nut

Documentation lives in `docs/` and is configured for Read the Docs with
`.readthedocs.yaml`.

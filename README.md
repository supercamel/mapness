<h1>Mapness</h1>

<p>Mapness is a Gtk+ map widget with a focus on being roughly equivalent to
Google Maps.

<p>Mapness can source maps from Open street maps, Google Maps and Virtual Earth.
<br>

Mapness has been inspired by the OsmGpsMap, but unlike OsmGpsMap it is written
in the Vala programming language. The benefits of Vala are
<ul>
    <li>faster and less tedious to develop with</li>
    <li>similar performance to C</li>
    <li>it's harder to write buggy code with</li>
    <li>generates very clean bindings with gir</li>
</ul>

<p>Please see https://github.com/nzjrs/osm-gps-map
for the list of OsmGpsMap authors.

<p>It's easy to generate bindings of Mapness for other languages.
<p>To build C sources, use 'make c'.
<p>To build a typelib file to Javascript and Python, use 'make typelib'
<p>Other language bindings shouldn't be too difficult, but documentation on
using gobject introspection seems a little hard to come by!
<p>To install everything, please check the INCDIR, LIBDIR, VAPIDIR and
TYPELIBDIR variables are correct in the makefile. If they are OK, use make install.

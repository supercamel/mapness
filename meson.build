
project('mapness', 'vala', 'c',
  version: '2.0.0')

gnome = import('gnome')
pkg = import('pkgconfig')
mapness_version = meson.project_version()
mapness_api_version = '2.0'
mapness_api_name = 'mapness-' + mapness_api_version
gi_dep = dependency('gobject-introspection-1.0')
gir_install_dir = gi_dep.get_variable(pkgconfig: 'girdir')
typelib_install_dir = gi_dep.get_variable(pkgconfig: 'typelibdir')

dependencies = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gtk4'),
  dependency('libsoup-3.0'),
  dependency('gdk-pixbuf-2.0'),
  dependency('gee-0.8'),
  meson.get_compiler('c').find_library('m', required: false)
  ]

sources = files('src/mapness.vala', 'src/controls.vala', 'src/image.vala', 'src/layer.vala', 'src/point.vala', 'src/polygon.vala', 'src/source.vala', 'src/track.vala')


libmapness = shared_library('mapness', sources,
  vala_header: 'mapness.h',
  vala_vapi: mapness_api_name + '.vapi',
  vala_gir: mapness_api_name + '.gir',
  dependencies: dependencies,
  install: true,
  install_dir: [true, true, true, gir_install_dir])


g_ir_compiler = find_program('g-ir-compiler')
custom_target('mapness typelib', command: [g_ir_compiler, '--shared-library', 'libmapness.so', '--output', '@OUTPUT@', meson.current_build_dir() / (mapness_api_name + '.gir')],
  output: mapness_api_name + '.typelib',
  depends: libmapness,
  install: true,
  install_dir: typelib_install_dir)

pkg.generate(libmapness,
  filebase: mapness_api_name,
  name: 'mapness',
  description: 'a GTK4 map widget',
  version: mapness_version,
  requires: ['gtk4', 'libsoup-3.0', 'gdk-pixbuf-2.0', 'gee-0.8'])

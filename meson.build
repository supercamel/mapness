
project('mapness', 'vala', 'c')

gnome = import('gnome')
mapness_version = '1.0'

dependencies = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gtk+-3.0'),
  dependency('libsoup-2.4'),
  dependency('gee-0.8'),
  meson.get_compiler('c').find_library('m', required: false)
  ]

sources = files('src/mapness.vala', 'src/controls.vala', 'src/image.vala', 'src/layer.vala', 'src/point.vala', 'src/polygon.vala', 'src/source.vala', 'src/track.vala')


libmapness = shared_library('mapness', sources,
  vala_header: 'mapness.h',
  vala_vapi: 'mapness-1.0.vapi',
  vala_gir: 'mapness-1.0.gir',
  dependencies: dependencies,
  install: true,
  install_dir: [true, true, true, true])


g_ir_compiler = find_program('g-ir-compiler')
custom_target('mapness typelib', command: [g_ir_compiler, '--output', '@OUTPUT@', meson.current_build_dir() / 'mapness-1.0.gir'],
  output: 'mapness-1.0.typelib',
  depends: libmapness,
  install: true,
  install_dir: get_option('libdir') / 'girepository-1.0')


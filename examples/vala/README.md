# Vala Examples

Run after installing mapness:

```sh
valac --pkg gtk4 --pkg mapness-2.0 main.vala -o mapness-vala-example
./mapness-vala-example
```

Run against an uninstalled development build from the project root:

```sh
PKG_CONFIG_PATH=builddir/meson-uninstalled \
  valac --vapidir=builddir --pkg gtk4 --pkg mapness-2.0 \
  examples/vala/main.vala -o /tmp/mapness-vala-example

LD_LIBRARY_PATH=builddir /tmp/mapness-vala-example
```

# SQGI Examples

Run these from this folder after installing mapness:

```sh
sqgi main.nut
sqgi measure.nut
sqgi polygon.nut
```

Each example supports `--timeout=N` to close the GTK window automatically.

For an uninstalled development build, run from the project root with:

```sh
GI_TYPELIB_PATH=builddir LD_LIBRARY_PATH=builddir sqgi examples/sqgi/main.nut
```

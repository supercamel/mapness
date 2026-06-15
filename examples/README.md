# Examples

Examples are grouped by language:

```text
examples/
  gjs/
  python/
  sqgi/
  vala/
```

After installing mapness, run examples from their language folder:

```sh
cd examples/python && python3 main.py
cd examples/gjs && gjs main.js
cd examples/sqgi && sqgi main.nut
cd examples/vala && valac --pkg gtk4 --pkg mapness-2.0 main.vala -o mapness-vala-example && ./mapness-vala-example
```

For an uninstalled development build, run from the project root with:

```sh
GI_TYPELIB_PATH=builddir LD_LIBRARY_PATH=builddir python3 examples/python/main.py
GI_TYPELIB_PATH=builddir LD_LIBRARY_PATH=builddir gjs examples/gjs/main.js
GI_TYPELIB_PATH=builddir LD_LIBRARY_PATH=builddir sqgi examples/sqgi/main.nut
```

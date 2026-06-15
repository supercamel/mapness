Installation
============

Dependencies
------------

Mapness is built with Meson and Vala. It depends on:

* GTK4
* libsoup3
* gdk-pixbuf
* Gee
* GObject Introspection

On Ubuntu-style systems, the package set is typically:

.. code-block:: sh

   sudo apt install \
     meson ninja-build valac gcc pkg-config \
     libgtk-4-dev libsoup-3.0-dev libgdk-pixbuf-2.0-dev \
     libgee-0.8-dev gobject-introspection libgirepository1.0-dev

Build From Source
-----------------

.. code-block:: sh

   meson setup builddir
   ninja -C builddir

Install
-------

.. code-block:: sh

   sudo meson install -C builddir
   sudo ldconfig

The install places the C library, header, VAPI, GIR, typelib, and pkg-config
file where language bindings can find them. The installed public names are:

* ``mapness-2.0.pc``
* ``mapness-2.0.vapi``
* ``mapness-2.0.gir``
* ``mapness-2.0.typelib``

Run Without Installing
----------------------

For local development, point GI and the dynamic linker at the build directory:

.. code-block:: sh

   GI_TYPELIB_PATH=builddir LD_LIBRARY_PATH=builddir \
     python3 examples/python/main.py

   GI_TYPELIB_PATH=builddir LD_LIBRARY_PATH=builddir \
     sqgi examples/sqgi/main.nut

For Vala examples against the uninstalled build, also point ``valac`` at the
generated VAPI:

.. code-block:: sh

   PKG_CONFIG_PATH=builddir/meson-uninstalled \
     valac --vapidir=builddir --pkg gtk4 --pkg mapness-2.0 \
     examples/vala/main.vala -o /tmp/mapness-vala-example

   LD_LIBRARY_PATH=builddir /tmp/mapness-vala-example

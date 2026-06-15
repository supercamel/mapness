Quick Start
===========

The smallest useful Mapness application creates a GTK window, creates a
``mapness.Map`` widget, chooses a tile source, and sets a center point and zoom.

Vala
----

Compile against an installed Mapness:

.. code-block:: sh

   cd examples/vala
   valac --pkg gtk4 --pkg mapness-2.0 main.vala -o mapness-vala-example
   ./mapness-vala-example

Python
------

Python uses GObject Introspection:

.. code-block:: python

   import gi

   gi.require_version("Gtk", "4.0")
   gi.require_version("mapness", "2.0")
   from gi.repository import Gtk, mapness

SQGI
----

SQGI imports the same GI namespace and version:

.. code-block:: javascript

   local Gtk = import("Gtk", "4.0")
   local Mapness = import("mapness", "2.0")

Run the SQGI example:

.. code-block:: sh

   cd examples/sqgi
   sqgi main.nut

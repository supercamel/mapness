Examples
========

The repository keeps examples under ``examples/``, grouped by language.

.. code-block:: text

   examples/
     vala/
     python/
     gjs/
     sqgi/

Vala
----

.. literalinclude:: ../examples/vala/main.vala
   :language: vala
   :caption: examples/vala/main.vala

Python
------

.. literalinclude:: ../examples/python/main.py
   :language: python
   :caption: examples/python/main.py

SQGI
----

.. literalinclude:: ../examples/sqgi/main.nut
   :language: javascript
   :caption: examples/sqgi/main.nut

More Examples
-------------

The Python folder also includes a track measuring example and a custom layer
example. The SQGI folder includes track measuring and polygon examples:

.. code-block:: sh

   cd examples/python && python3 measure.py
   cd examples/python && python3 layer.py

   cd examples/sqgi && sqgi measure.nut
   cd examples/sqgi && sqgi polygon.nut

SQGI examples accept ``--timeout=N`` to close the window automatically, and
otherwise run as normal GTK applications.

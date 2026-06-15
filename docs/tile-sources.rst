Tile Sources
============

Mapness defaults to OpenStreetMap:

.. code-block:: vala

   map.set_map_source(mapness.MapSource.OPENSTREETMAP);

The default OpenStreetMap URL template is:

.. code-block:: text

   https://tile.openstreetmap.org/#Z/#X/#Y.png

Custom OpenStreetMap-style Sources
----------------------------------

Use ``Source.custom`` for servers that follow ``/{z}/{x}/{y}.png`` style paths:

.. code-block:: vala

   var source = new mapness.Source.custom("https://tiles.example.com");
   map.set_source(source);

The custom source appends ``/#Z/#X/#Y.png`` after trimming trailing slashes.

Cache
-----

Tiles are cached under:

.. code-block:: text

   $XDG_CACHE_HOME/mapness/<source name>/

or, when ``XDG_CACHE_HOME`` is not set:

.. code-block:: text

   ~/.cache/mapness/<source name>/

The cache directory can be overridden through ``Map.cache_dir``.

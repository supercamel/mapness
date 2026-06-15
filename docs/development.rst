Development
===========

Build And Check
---------------

.. code-block:: sh

   meson setup builddir
   ninja -C builddir

   GI_TYPELIB_PATH=builddir LD_LIBRARY_PATH=builddir \
     python3 -m py_compile examples/python/*.py

Build Documentation Locally
---------------------------

.. code-block:: sh

   python3 -m venv /tmp/mapness-docs-venv
   /tmp/mapness-docs-venv/bin/pip install -r docs/requirements.txt
   /tmp/mapness-docs-venv/bin/sphinx-build -b html docs /tmp/mapness-docs-html

Read the Docs
-------------

The repository includes ``.readthedocs.yaml``. Read the Docs builds
``docs/conf.py`` with Sphinx and installs ``docs/requirements.txt`` before
building.

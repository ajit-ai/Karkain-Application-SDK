Getting Started
===============

.. contents:: Sections

Getting Started
----------------

Install the Karkain compiler (v1.2.0 or later, v1.2.x compatibility line):

.. code-block:: bash

   git clone https://github.com/ajit-ai/Karkain.git
   cd Karkain
   go build -o karkain.exe ./cmd/karkain
   ./karkain --version

Build and run the SDK example:

.. code-block:: bash

   karkain run examples/hello.kark

The example orchestrates the application through ``app_run_state``: it creates
application state, starts the application, runs the service, shuts down and
handles the final outcome (``Ok`` / ``Err``).

Run the SDK tests:

.. code-block:: bash

   karkain test tests

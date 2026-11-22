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

The example exercises the service-handler dispatch contract
``app_dispatch(name, port, service_id, service_input)`` three times:

1. service A (``service_id = 1``) with input ``21`` -> ``Ok(42)``;
2. service B (``service_id = 2``) with input ``7`` -> ``Ok(21)``;
3. an unknown identifier (``99``) -> controlled ``Err("unknown service")``.

Each call receives an ``AppOutcome`` holding the final application state and
the execution result. The example prints the final ``started`` / ``running``
flags (the application is stopped in every case) and handles each outcome
with ``match``.

Run the SDK tests:

.. code-block:: bash

   karkain test tests

The focused suite covers dispatch to each handler, distinct handler
results, caller-provided input propagation, preservation of the original
handler error, unknown-service handling, the stopped final state after
success and failure, and backward compatibility of ``app_run``,
``app_run_state`` and ``app_run_service``.

.. note::

   Dispatch is static: service identifiers are integers routed by a
   conditional chain. Function-value / callback dispatch and dynamic
   registration are not supported on the Karkain v1.2.x line.

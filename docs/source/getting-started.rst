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
``app_dispatch(name, port, service_id, service_input)`` and the
environment-driven configuration API ``app_run_configured(name, port)``.

Configuration variables (set in the *host process* environment, not from
within the Karkain example itself):

===  ====================================================== ==========
Variable                      Purpose              Default
===  ====================================================== ==========
``KARKAIN_APP_SERVICE_ID``   Select service handler    ``0``
``KARKAIN_APP_SERVICE_INPUT`` Provide service input  ``21``
===  ====================================================== ==========

The example runs three scenarios in sequence (each scenario requires the
corresponding environment variable(s) to be set in the host PowerShell
session before running the command):

Scenario 1 — default configuration (no env vars set):

.. code-block:: powershell

   karkain run examples/hello.kark

   Output: ``0`` (stopped), ``42`` (``Ok(21 * 2)``, service 0 with input 21),
           ``[INFO] default service completed``.

   This exercises the documented defaults: ``KARKAIN_APP_SERVICE_ID`` absent
   → service id 0, ``KARKAIN_APP_SERVICE_INPUT`` absent → input 21.

Scenario 2 — explicit service selection:

.. code-block:: powershell

   # Select service B (handler ``app_service_b``, triple input) with input 7.
   $env:KARKAIN_APP_SERVICE_ID = "2"
   $env:KARKAIN_APP_SERVICE_INPUT = "7"
   karkain run examples/hello.kark

   Output: ``0`` (stopped), ``21`` (``Ok(7 * 3)``), ``[INFO] service B completed``.

   The ``KARKAIN_APP_SERVICE_ID`` value ``"2"`` selects service B via the
   static dispatch chain; the ``"7"`` input is validated by the
   ``config_service_input`` helper and delivered to the handler.

Scenario 3 — invalid configuration:

.. code-block:: powershell

   # An unrecognized service ID; controlled error, application stops.
   $env:KARKAIN_APP_SERVICE_ID = "99"
   karkain run examples/hello.kark

   Output: ``0`` (stopped), ``[ERROR] invalid service ID``.

   Similarly, ``KARKAIN_APP_SERVICE_INPUT = "99"`` (unrecognized input)
   yields ``[ERROR] invalid service input``.

Run the SDK tests:

.. code-block:: bash

   karkain test tests

The focused suite covers dispatch to each handler, distinct handler results,
configuration defaults, invalid-configuration handling, the stopped final
state after success and failure, and backward compatibility of ``app_run``,
``app_run_state``, ``app_run_service``, and ``app_dispatch``.

.. note::

   Configuration is **host-process only**: the Karkain example cannot
   modify its own environment variables. Each scenario requires the host
   PowerShell session to set the vars before running ``karkain run``.

   Dispatch is static: service identifiers are integers routed by a
   conditional chain. Function-value / callback dispatch and dynamic
   registration are not supported on the Karkain v1.2.x line.
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

Lifecycle events are emitted at each stage of execution:

- **Created** (event ID 1) — when the application is instantiated.
- **Started** (event ID 2) — when the application enters the running phase.
- **Before dispatch** (event ID 3) — just prior to service selection.
- **After dispatch** (event ID 4) — after the handler completes, carrying the
  actual service outcome.
- **Shutdown** (event ID 5) — after the application shuts down.

Configuration profiles group application settings into consistent, validated
structures that can be used to construct application execution context.

- **Default profile** (identifier 0): application name ``karkain-app``, port 8080,
  service ID 0 (built-in demonstration), service input 21, debug mode disabled.
- **Development profile** (identifier 1): application name ``karkain-dev``, port 8081,
  service ID 1 (service A), service input 7, debug mode enabled.
- **Production profile** (identifier 2): application name ``karkain-prod``, port 8082,
  service ID 2 (service B), service input 21, debug mode disabled.

Each scenario requires the corresponding environment variable(s) to be set
in the host PowerShell session before running the command:

Scenario 1 — default configuration (no env vars set):

.. code-block:: powershell

   karkain run examples/hello.kark

   Output: ``0`` (stopped), ``42`` (``Ok(21 * 2)``, service 0 with input 21),
   lifecycle events: created(1), started(2), after-dispatch(4), shutdown(5).

   This exercises the documented defaults: ``KARKAIN_APP_SERVICE_ID`` absent
   → service id 0, ``KARKAIN_APP_SERVICE_INPUT`` absent → input 21.

Scenario 2 — explicit service selection:

.. code-block:: powershell

   # Select service B (handler ``app_service_b``, triple input) with input 7.
   $env:KARKAIN_APP_SERVICE_ID = "2"
   $env:KARKAIN_APP_SERVICE_INPUT = "7"
   karkain run examples/hello.kark

   Output: ``0`` (stopped), ``21`` (``Ok(7 * 3)``), lifecycle events as above.

   The ``KARKAIN_APP_SERVICE_ID`` value ``"2"`` selects service B via the
   static dispatch chain; the ``"7"`` input is validated by the
   ``config_service_input`` handler and delivered to the handler.

Scenario 3 — invalid configuration:

.. code-block:: powershell

   # An unrecognized service ID; controlled error, lifecycle events still emitted.
   $env:KARKAIN_APP_SERVICE_ID = "99"
   karkain run examples/hello.kark

   Output: ``0`` (stopped), ``[ERROR] invalid service ID``, lifecycle events as above.

   Similarly, ``KARKAIN_APP_SERVICE_INPUT = "99"`` (unrecognized input)
   yields ``[ERROR] invalid service input``.

Configuration profiles can be constructed and validated through the SDK's
profile APIs before execution:

.. code-block:: karkain

   let cfg = app_config_select(1)   // development profile
   let valid = app_config_validate(cfg)
   let ctx = app_config_to_context(cfg)

Run the SDK tests:

.. code-block:: bash

   karkain test tests

The focused suite covers lifecycle event construction and order, service A
and B execution events, unknown-service and failure event behavior, the
stopped final state after success and failure, and backward compatibility
of ``app_run``, ``app_run_state``, ``app_run_service``, ``app_dispatch``,
``app_context_create``, ``app_context_config_get``, ``app_context_config_has``,
``app_service_a_context``, and ``app_service_b_context``.

.. note::

   Configuration is **host-process only**: the Karkain example cannot
   modify its own environment variables. Each scenario requires the host
   PowerShell session to set the vars before running ``karkain run``.

   Lifecycle events are emitted at real execution stages and correspond to
   the shared single lifecycle path (create → start → dispatch → shutdown).
   Event processing uses only verified Karkain v1.2.x capabilities
   (integer constants, struct fields, helper functions). No dynamic
   registration, callbacks, or asynchronous delivery is supported.

   Dispatch is static: service identifiers are integers routed by a
   conditional chain. Function-value / callback dispatch and dynamic
   registration are not supported on the Karkain v1.2.x line.

   Configuration profiles provide a static, compile-time determined set of
   profiles (identifiers 0, 1, 2) that can be selected and validated before
   application execution. They are not a dynamic configuration loader or
   environment detection mechanism.

   The service context ``AppContext`` carries application metadata
   (name, port, service ID and input) to handlers through the
   ``app_context_create`` function and the shared ``app_dispatch`` path.
   Context fields are also available in the ``AppState`` returned by
   ``app_dispatch`` via ``res.state``.

.. note::
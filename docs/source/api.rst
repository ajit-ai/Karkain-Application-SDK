API Reference
=============

.. contents:: Sections

API Reference
-------------

The public API boundary of the Karkain Application SDK is declared in
``src/app.kark`` and documented module by module in this section. Each module
lists its initial functions and their verified Karkain capability basis.

Service dispatch API
--------------------

The dispatch slice adds synchronous service-handler selection on top of the
verified Karkain v1.2.x language features (struct state, functions with
inferred returns, ``Result`` values, ``match``, integer comparison).

Dispatch is **static**: service identifiers are integers routed by a
conditional chain inside ``app_dispatch_service``. Function-value / callback
dispatch and dynamic registration are NOT supported on this language line
(verified C compilation failure), so handlers are wired statically in source.

* ``app_dispatch(name, port, service_id, service_input)`` -> ``AppOutcome``
  -- the common service execution contract:

  1. accepts a caller-selected ``service_id`` (integer),
  2. accepts caller-provided ``service_input``,
  3. creates application state, starts it, routes to the selected handler,
  4. attempts shutdown after successful execution and after controlled
     handler failure,
  5. returns ``AppOutcome{ state, outcome }`` with the final (stopped)
     application state and the selected handler's result.

* ``app_dispatch_service(service_id, service_input)`` -> ``Result`` -- the
  pure routing function (no lifecycle). Returns the selected handler's
  result, or a controlled ``Err`` for an unknown identifier.

Service identifier contract
----------------===========

===================  ==========================  =============================
``service_id``       Handler                     Behavior
===================  ==========================  =============================
``0``                ``app_service``             built-in demonstration service:
                                                ``Ok(n * 2)`` /
                                                ``Err("service failure:
                                                negative input")``
``1``                ``app_service_a``           service A: ``Ok(n * 2)`` /
                                                ``Err("service a failure:
                                                negative input")``
``2``                ``app_service_b``           service B: ``Ok(n * 3)`` /
                                                ``Err("service b failure:
                                                negative input")``
anything else        none                        controlled
                                                ``Err("unknown service")``
===================  ==========================  =============================

Input and output semantics
--------------------------

* ``service_input`` is an integer supplied by the caller and passed
  unchanged to the selected handler.
* Each handler returns ``Ok(n * 2)`` or ``Ok(n * 3)`` for non-negative
  input, and a handler-specific ``Err`` for negative input.
* Handlers A and B are genuinely different operations (double vs. triple),
  so dispatch is demonstrably not forwarding every request to one service.
* The handler's original error text is preserved in the returned outcome.

Unknown-service behavior
------------------------

An unknown or unsupported ``service_id`` yields the controlled error
``Err("unknown service")``. The application still runs the full lifecycle
and reaches the stopped state (``started = false``, ``running = false``).

Lifecycle and shutdown behavior
-------------------------------

The logical lifecycle is ``created -> started -> running -> stopped``:

* Created: ``started = false``, ``running = false``.
* Started/running: ``started = true``, ``running = true``.
* Stopped: ``started = false``, ``running = false``.

``app_dispatch`` is the single shared lifecycle path (create -> start ->
dispatch -> shutdown); handlers contain no lifecycle logic. Shutdown is
attempted unconditionally after the handler returns, so the application
always ends stopped. The service outcome takes error precedence.

Documented limitation: shutdown returns state only and provides no
shutdown-failure signal.

Relationship to the run APIs
----------------------------

* ``app_orchestrate(name, port, service_input)`` -> ``AppOutcome`` --
  delegates to ``app_dispatch(name, port, 0, service_input)`` so the legacy
  demonstration service shares the same single lifecycle path.
* ``app_run_state(name, port, service_input)`` -> ``AppOutcome`` --
  backward compatible orchestration entry point (final state + outcome).
* ``app_run_service(name, port, service_input)`` -> ``AppOutcome`` --
  backward compatible configurable service execution contract.
* ``app_run(name, port)`` -> outcome -- backward compatible entry point
  that runs the demonstration service (service id ``0``) with the SDK
  demonstration input and returns only the final service outcome.

All four preserve their established signatures and behavior; each routes
through ``app_dispatch``, so there is exactly one implementation of the
lifecycle sequence.

Application lifecycle API
-------------------------

* ``app_create(name, port)`` -- create application state
  (``AppState{ name, port, started, running }`` with ``started = false``,
  ``running = false``).
* ``app_start(state)`` -- transition state into the running phase
  (``started = true``, ``running = true``).
* ``app_shutdown(state)`` -- transition state to stopped
  (``started = false``, ``running = false``).
* ``app_config_name(state)`` -- read the configured application name.

Logging and configuration API
-----------------------------

* ``app_log_info(msg)`` / ``app_log_warn(msg)`` / ``app_log_error(msg)`` /
  ``app_log_debug(msg)`` / ``app_log_with_time(level, msg)`` -- structured
  logging wrappers over the verified ``std.log`` capability.
* ``app_config_get(name, default_val)`` / ``app_config_has(name)`` -- environment
  configuration wrappers over the verified ``std.env`` capability.

These wrappers cannot be called from the test-compilation path on this
language line (verified), so they are exercised by the example run and
validated by the source check.

See the project ``README.md`` for the authoritative module list.

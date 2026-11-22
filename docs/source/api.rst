API Reference
=============

.. contents:: Sections

API Reference
-------------

The public API boundary of the Karkain Application SDK is declared in
``src/app.kark`` and documented module by module in this section. Each module
lists its initial functions and their verified Karkain capability basis.

Application lifecycle API
-------------------------

The implementation slices add the smallest reliable lifecycle surface on top of
verified Karkain v1.2.x language features (struct state, functions with
inferred returns, ``Result`` values, ``match``).

* ``app_run_state(name, port, service_input)`` -> ``AppOutcome`` -- orchestrate
  the verified lifecycle slice and return both the final application state and
  the service execution outcome:

  - create state -> start -> run service -> shutdown,
  - final state: ``AppState`` after shutdown (``started = false``),
  - outcome: ``Ok(payload)`` on successful service execution, ``Err`` on
    controlled service failure (error preserved).

* ``app_run(name, port)`` -> outcome -- backward-compatible orchestration
  entry point that runs the same lifecycle (with the SDK demonstration service
  input) and returns only the final service outcome (``Ok`` payload on success,
  ``Err`` on controlled failure).

* ``app_orchestrate(name, port, service_input)`` -> ``AppOutcome`` -- shared
  internal orchestration returning final state plus outcome.

* ``app_create(name, port)`` -- create application state
  (``AppState{ name, port, started }`` with ``started = false``).
* ``app_start(state)`` -- transition state to ``started = true``.
* ``app_shutdown(state)`` -- transition state to ``started = false``.
* ``app_config_name(state)`` -- read the configured application name.
* ``app_service(n)`` -- run the service: ``Ok(n * 2)`` on success, ``Err`` on
  controlled failure.

Logging and configuration API
-----------------------------

* ``app_log_info(msg)`` / ``app_log_warn(msg)`` / ``app_log_error(msg)`` /
  ``app_log_debug(msg)`` / ``app_log_with_time(level, msg)`` -- structured
  logging wrappers over the verified ``std.log`` capability.
* ``app_config_get(name, default_val)`` / ``app_config_has(name)`` -- environment
  configuration wrappers over the verified ``std.env`` capability.

See the project ``README.md`` for the authoritative module list.

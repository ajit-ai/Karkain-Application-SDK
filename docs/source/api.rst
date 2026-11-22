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

  1. creates application state, starts it, routes to the selected handler,
  2. attempts shutdown after successful execution and after controlled
     handler failure,
  3. returns ``AppOutcome{ state, outcome }`` with the final (stopped)
     application state and the selected handler's result.

* ``app_dispatch_service(service_id, service_input)`` -> ``Result`` -- the
  pure routing function (no lifecycle). Returns the selected handler's
  result, or a controlled ``Err`` for an unknown identifier.

Environment-driven configuration API
------------------------------------

* ``app_run_configured(name, port)`` -> ``AppOutcome`` -- the configured
  service execution contract. Reads ``KARKAIN_APP_SERVICE_ID`` and
  ``KARKAIN_APP_SERVICE_INPUT`` from the process environment through the
  existing ``app_config_get`` / ``app_config_has`` wrappers. Defaults are
  applied only when the variables are absent. Validated values are passed
  to ``app_dispatch``; unrecognized values produce a controlled ``Err``
  outcome and the application still reaches the stopped state.

  - ``KARKAIN_APP_SERVICE_ID``: selects service handler.
    Accepted values (as strings): ``"0"``, ``"1"``, ``"2"``.
    Default: ``0`` (the built-in demonstration service ``app_service``).
    If the variable is present but its value is not one of the accepted
    strings, a controlled ``Err("invalid service ID")`` is returned; the
    default is NOT silently substituted.

  - ``KARKAIN_APP_SERVICE_INPUT``: provides the caller-supplied service
    input integer. Accepted string values: ``"0"``, ``"1"``, ``"2"``,
    ``"7"``, ``"21"``. Default: ``21`` (the SDK demonstration input).
    If the variable is present but its value is not one of the accepted
    strings, a controlled ``Err("invalid service input")`` is returned;
    the default is NOT silently substituted.

  Both variables are resolved through the SDK module's ``app_config_get``
  (``env_get_or``) and ``app_config_has`` (``env_has``) functions, which
  are verified working on the Karkain v1.2.x line (exit 0 in check and
  build modes; exercised by the example and the full test suite).

  The configuration resolution is kept separate from service execution:
  ``app_run_configured`` reads the env vars, validates them through
  verified string-equality helpers, and delegates the lifecycle execution
  to the single shared ``app_dispatch`` path.

Dispatch is static, not dynamic. The service identifier meanings and
handler calculations are unchanged from the preceding dispatch slice.

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
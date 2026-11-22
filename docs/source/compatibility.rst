Compatibility
=============

The Karkain Application SDK targets the Karkain compiler v1.2.0 minimum
supported version with a v1.2.x compatibility target.

* Minimum supported compiler: Karkain v1.2.0.
* Compatibility target: Karkain v1.2.x.
* Supported engines: Go front end and self-hosted ``kcc`` engine where the
  engine is executable on the host. The currently validated execution path is
  the Go engine (``--engine go``); the self-hosted ``kcc`` engine is not usable
  on this host.
* Native execution requires a host C compiler (GCC/Clang/MSVC) for the C23
  backend.

Application lifecycle behaviour in this slice:

* Startup: ``app_start`` transitions state to started and emits structured
  startup logging.
* Shutdown: ``app_shutdown`` transitions state to shutdown.
* Error handling: services return ``Ok`` / ``Err``; error paths are reported
  through the error logging wrappers and ``match`` handling.

Anything labelled ``Planned`` / ``Not Yet Implemented`` is not part of the
supported API.

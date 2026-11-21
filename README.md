# Karkain Application SDK

> **Status:** Foundation established (Phase B/D) — first implementation slice in progress (Phase E).

The **Karkain Application SDK** is an independent public Karkain package that
establishes the engineering foundation for native Karkain applications and
begins the first working product: a Karkain application that can start, load
configuration, produce consistently formatted logs, handle an application error,
run a service and shut down cleanly.

## Positioning

Balanced market positioning, balanced optimization priority.

## Module boundaries

- lifecycle
- configuration
- logging
- errors
- events
- services
- resources
- tasks
- serialization
- testing
- packaging

## First working product

A native Karkain application that can:

1. start,
2. load configuration,
3. produce structured or consistently formatted logs,
4. handle an application error,
5. run a service,
6. shut down cleanly.

## Implemented in the first slice

- Application entry point and lifecycle hooks.
- Configuration loading through verified environment APIs (`std.env`).
- Structured / consistently formatted logging through verified logging APIs
  (`std.log`).
- Standard application error handling through Karkain `Result` / `Option` and
  `match` / `?` error propagation.
- Minimal service integration through task execution (`spawn` / `join`).
- Clean shutdown and resource cleanup conventions.

## Compiler compatibility

- Minimum supported compiler: Karkain v1.2.0.
- Compatibility target: Karkain v1.2.x.
- Verified capabilities are recorded per capability in the capability audit.

## Quick start

```bash
karkain run examples/hello.kark
karkain check src/app.kark
karkain test tests
```

## License

MIT — see [LICENSE](LICENSE).

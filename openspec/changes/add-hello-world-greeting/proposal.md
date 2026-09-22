# Proposal

## Why

The project has no runnable code yet. This change establishes the hexagonal
architecture skeleton by delivering a working CLI greeter — proving that the
domain core is fully decoupled from its driving adapter and can later serve
HTTP on AWS Lambda without any domain change.

## What Changes

- New `Greeting` value object: immutable, holds `guest_name` and `greeted_at`; no presentation logic.
- New `GuestName` value object: validates presence, max 64 chars, rejects control/escape characters, strips and title-cases surrounding whitespace.
- New `GreetingService` use case: accepts a raw name string and an injected `Clock`; returns a `Greeting`.
- New `Clock` port: single method `#now`; driven side, injected via constructor keyword argument.
- New `GreetingPresenter` port: single method `#present(greeting)`; driving side.
- New `SystemClock` adapter: wraps `Time.now.utc`.
- New `CliPresenter` adapter: formats `"Hello, <Name>!"` and writes to an injected `IO` (default `$stdout`).
- New `exe/greeter` executable: wires the full object graph using constructor keyword arguments; exits 2 with a stderr message on invalid input.
- RSpec unit tests per layer (domain, ports, adapters) written before each implementation file.
- Cucumber features with one scenario per spec requirement, each tagged with the requirement name.
- `benchmark-ips` guard asserting p99 single-invocation latency under 5 ms.

Greeting history and persistence are **explicitly out of scope** for this change.

## Capabilities

### New Capabilities

- `greeting/cli-greeter`: CLI greeting service — validates a guest name, constructs a `Greeting` via `GreetingService`, and presents it through `CliPresenter`.

### Modified Capabilities

_(none)_

## Impact

- Introduces `lib/greeter/domain/`, `lib/greeter/ports/`, and `lib/greeter/adapters/` directory structure.
- Adds `exe/greeter` entry point.
- No new runtime gem dependencies; `benchmark-ips` already present in the `Gemfile` dev group.
- The domain layer has zero gem dependencies and never calls `Time.now` directly.
- Trade-off decisions applied from prior exploration:
  - **Greeting text**: `Greeting` is a structured value object (`guest_name`, `greeted_at`); adapters own all presentation formatting.
  - **Timestamp**: `Clock` port injected via constructor keyword argument; `SystemClock` adapter in production, `FakeClock` in tests.
  - **History**: deferred to the future Lambda/HTTP change.

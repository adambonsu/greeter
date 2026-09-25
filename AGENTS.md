# Project conventions

## Architecture: Hexagonal (three layers only)

| Layer | Path | Rules |
|---|---|---|
| Domain | `lib/greeter/domain` | Pure Ruby, zero gems, zero I/O, no AWS, no `Time.now` |
| Ports | `lib/greeter/ports` | Abstract interfaces (driving + driven); unimplemented methods raise `NotImplementedError` |
| Adapters | `lib/greeter/adapters` | All I/O: CLI, HTTP/Lambda, DynamoDB, in-memory fakes |

## Dependency rule

Dependencies point **inward only**. `domain` must not reference `adapters`.

## Dependency injection

All collaborators are injected via constructor keyword arguments. No globals, no singletons, no `require` of adapter files from domain files.

## TDD

Write the failing RSpec example before the implementation, in the same commit.

## OpenSpec ↔ Cucumber traceability

Every OpenSpec spec scenario maps to exactly one Cucumber scenario, tagged with the requirement name.

## Toolchain

- Ruby 3.3.5
- `# frozen_string_literal: true` on every file
- RuboCop clean (no offenses)

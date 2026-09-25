# Design

## Context

Greenfield project. No existing `lib/` code. The Gemfile already includes
`rspec`, `cucumber`, `benchmark-ips`, and `rubocop`. The hexagonal layer
structure (`domain` / `ports` / `adapters`) is mandated by `AGENTS.md`.
See `proposal.md` for motivation.

## Goals / Non-Goals

**Goals:**
- Establish the three-layer directory structure under `lib/greeter/`.
- Prove the hexagonal seam: the domain core is exercisable without any adapter.
- Deliver a working `exe/greeter` CLI wired entirely through constructor keyword arguments.
- Provide a `FakeClock` test double that makes domain tests deterministic and fast.

**Non-Goals:**
- Greeting history or persistence (deferred to the Lambda/HTTP change).
- HTTP, Lambda, or DynamoDB adapters.
- Internationalisation or locale-aware formatting.

## Decisions

### D1: Greeting value object carries data only; adapters own presentation

`Greeting` holds `guest_name` (a `GuestName`) and `greeted_at` (a `Time`).
It exposes no `#to_s` or `#message` method. `CliPresenter` reads those fields
and formats the string `"Hello, #{greeting.guest_name.display}!"`.

Alternative considered: a `#message` method on `Greeting`. Rejected because it
would embed presentation logic in the domain, making the domain aware of how
text should look — a concern that belongs to the adapter layer. Future adapters
(JSON envelope for Lambda, HTML for a web view) would receive a pre-formatted
string they cannot reuse.

### D2: Clock port injected via constructor keyword argument

`GreetingService` receives `clock:` at construction. `SystemClock#now` returns
`Time.now.utc`; `FakeClock` accepts a fixed `Time` at construction and returns
it from `#now`. `Time.now` never appears in domain or port files.

Alternative considered: passing `time:` as a keyword argument to
`GreetingService#greet`. Rejected because it pushes the responsibility for
knowing about time onto every call site (the adapter must remember to pass it),
and it makes the dependency implicit rather than a named, visible seam in the
constructor signature.

### D3: GuestName validates eagerly and raises on construction

`GuestName.new(raw)` raises `Greeter::Domain::InvalidGuestName` (a subclass of
`ArgumentError`) immediately if the raw string fails any validation rule.
`GreetingService` does not rescue — it lets the exception propagate to the
adapter. The CLI adapter rescues `InvalidGuestName`, writes to stderr, and exits 2.

Alternative considered: returning a result object (`Success`/`Failure`). Rejected
for this scope because it adds a result-monad pattern with no other use site yet.
The exception approach is idiomatic Ruby and keeps the domain small.

### D4: GreetingPresenter port is a driving-side interface

`Greeter::Ports::GreetingPresenter` declares `#present(greeting)` and raises
`NotImplementedError`. `CliPresenter` implements it. This makes the port
explicit and testable in isolation, and documents the contract a future
`LambdaPresenter` must satisfy.

### D5: Object graph wired in exe/greeter, not in a service locator

`exe/greeter` is the single composition root. It constructs `SystemClock`,
`CliPresenter`, and `GreetingService` in sequence, passing each dependency as
a keyword argument. No global registry, no `require` of adapter files from
domain files.

## Non-functional constraints

- Domain layer (`lib/greeter/domain/`) has zero gem dependencies.
- `Time.now` appears only in `SystemClock`.
- No user input is interpolated into a shell command or log line unescaped.
- Every file carries `# frozen_string_literal: true`.
- RuboCop must report zero offenses.
- Test strategy: RSpec unit tests per layer written before each implementation
  file (TDD, same commit); Cucumber features with one scenario per spec
  requirement tagged with the requirement name; `benchmark-ips` guard for the
  latency requirement.

## Risks / Trade-offs

- `GuestName` title-casing uses `String#split` + `#capitalize` — correct for
  ASCII names, not for Unicode edge cases (e.g. "ñoño"). Acceptable for this
  scope; a Unicode-aware library can be swapped in the adapter layer later
  without touching the domain.
- The `benchmark-ips` latency guard runs in-process and measures Ruby object
  allocation, not OS process startup. The 5 ms budget applies to
  `GreetingService#greet`, not to `exe/greeter` cold-start. This is documented
  in the benchmark spec.

## Migration Plan

Greenfield — no migration required. `exe/greeter` is a new executable; add it
to `.gitignore` exclusions if needed and ensure `chmod +x exe/greeter` is part
of the setup task.

## Open Questions

_(none)_

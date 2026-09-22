# Tasks

## 1. Project skeleton

- [ ] 1.1 Create `lib/greeter/domain/`, `lib/greeter/ports/`, and `lib/greeter/adapters/` directories with `.gitkeep`; verify `bundle exec rspec` still exits 0
- [ ] 1.2 Add `# frozen_string_literal: true` to `spec/spec_helper.rb` and `features/support/env.rb`; verify `bundle exec rubocop` exits 0

## 2. Ports

- [ ] 2.1 Write a failing RSpec example for `Greeter::Ports::Clock` asserting `#now` raises `NotImplementedError`; then create `lib/greeter/ports/clock.rb` to make it pass; verify spec is green
- [ ] 2.2 Write a failing RSpec example for `Greeter::Ports::GreetingPresenter` asserting `#present` raises `NotImplementedError`; then create `lib/greeter/ports/greeting_presenter.rb` to make it pass; verify spec is green

## 3. Domain — value objects

- [ ] 3.1 Write failing RSpec examples for `Greeter::Domain::GuestName` covering: valid name strips whitespace and title-cases, empty/whitespace raises `InvalidGuestName`, name > 64 chars raises `InvalidGuestName`, control/escape characters raise `InvalidGuestName`; then create `lib/greeter/domain/guest_name.rb` to make all pass; verify specs are green
- [ ] 3.2 Write a failing RSpec example for `Greeter::Domain::Greeting` asserting it holds `guest_name` and `greeted_at` and is frozen; then create `lib/greeter/domain/greeting.rb` to make it pass; verify spec is green

## 4. Domain — use case

- [ ] 4.1 Write failing RSpec examples for `Greeter::Domain::GreetingService#greet` covering: returns a `Greeting` with correct `guest_name` and `greeted_at` from injected `FakeClock`, propagates `InvalidGuestName` for bad input; then create `lib/greeter/domain/greeting_service.rb` to make all pass; verify specs are green

## 5. Adapters

- [ ] 5.1 Write a failing RSpec example for `Greeter::Adapters::FakeClock` asserting `#now` returns the fixed time passed at construction; then create `lib/greeter/adapters/fake_clock.rb` to make it pass; verify spec is green
- [ ] 5.2 Write a failing RSpec example for `Greeter::Adapters::SystemClock` asserting `#now` returns a `Time` instance close to `Time.now.utc`; then create `lib/greeter/adapters/system_clock.rb` to make it pass; verify spec is green
- [ ] 5.3 Write failing RSpec examples for `Greeter::Adapters::CliPresenter` covering: writes `"Hello, Alice!\n"` to the injected IO for a valid `Greeting`; then create `lib/greeter/adapters/cli_presenter.rb` to make all pass; verify specs are green

## 6. Cucumber features

- [ ] 6.1 Create `features/greeting/cli_greeter.feature` with one scenario per spec requirement, each tagged with the requirement name (e.g. `@greets-a-named-guest`); verify `bundle exec cucumber --dry-run` lists all six scenarios without error
- [ ] 6.2 Implement step definitions in `features/step_definitions/cli_greeter_steps.rb` wiring through the object graph (using `FakeClock` for determinism); verify `bundle exec cucumber` exits 0 with all scenarios passing

## 7. Executable

- [ ] 7.1 Create `exe/greeter` that wires `SystemClock`, `CliPresenter` (injected with `$stdout`/`$stderr`), and `GreetingService` via constructor keyword arguments; rescues `InvalidGuestName`, writes to stderr, and exits 2; verify `bundle exec exe/greeter Alice` prints `Hello, Alice!` and exits 0
- [ ] 7.2 Verify `bundle exec exe/greeter ""` exits 2 and writes an error to stderr; verify `bundle exec exe/greeter "$(python3 -c 'print("a"*65)')"` exits 2

## 8. Latency benchmark

- [ ] 8.1 Create `spec/benchmarks/greeting_service_bench.rb` using `benchmark-ips` asserting that `GreetingService#greet` with a `FakeClock` completes in under 5 ms per iteration; verify the benchmark runs without failure via `bundle exec rspec spec/benchmarks/`

## 9. Quality gates

- [ ] 9.1 Run `bundle exec rubocop` and fix all offenses; verify exit 0
- [ ] 9.2 Run `bundle exec rspec` and confirm all examples pass; verify exit 0
- [ ] 9.3 Run `bundle exec cucumber` and confirm all scenarios pass; verify exit 0
- [ ] 9.4 Confirm no file under `lib/greeter/domain/` contains `require` of any file under `lib/greeter/adapters/`; verify by grep returning no matches

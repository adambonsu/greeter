# Spec Delta

## Purpose

Provides a CLI entry point that validates a guest name, constructs a time-stamped
greeting through the domain core, and presents it to the terminal — proving the
hexagonal seam between the CLI adapter and the domain without any persistence.

## ADDED Requirements

### Requirement: Greets a named guest
The system SHALL accept a guest name as a CLI argument, construct a `Greeting`
value object via `GreetingService`, and emit a formatted greeting line to stdout.

#### Scenario: Greets a named guest
- **WHEN** the CLI is invoked with a valid guest name (e.g. `greeter Alice`)
- **THEN** the process exits 0 and stdout contains `Hello, Alice!`

### Requirement: Normalises casing and whitespace
The system SHALL strip surrounding whitespace from the raw name input and
present the name in title case in the greeting output.

#### Scenario: Normalises casing and whitespace
- **WHEN** the CLI is invoked with a name that has surrounding whitespace or non-title casing (e.g. `greeter "  alice smith  "`)
- **THEN** the process exits 0 and stdout contains `Hello, Alice Smith!`

### Requirement: Rejects an empty or whitespace-only name
The system SHALL reject an empty or whitespace-only name with exit code 2 and
a human-readable error message on stderr; stdout SHALL be empty.

#### Scenario: Rejects an empty or whitespace-only name
- **WHEN** the CLI is invoked with an empty string or a string of only whitespace (e.g. `greeter ""`)
- **THEN** the process exits 2, stderr contains a message indicating the name is invalid, and stdout is empty

### Requirement: Rejects a name longer than 64 characters
The system SHALL reject any name whose length after whitespace-stripping exceeds
64 characters with exit code 2 and a human-readable error message on stderr.

#### Scenario: Rejects a name longer than 64 characters
- **WHEN** the CLI is invoked with a name longer than 64 characters after stripping
- **THEN** the process exits 2 and stderr contains a message indicating the name is too long

### Requirement: Rejects names containing control or escape characters
The system SHALL reject any name containing ASCII control characters (codepoints
0x00–0x1F, 0x7F) or escape sequences with exit code 2 and a human-readable
error message on stderr, as a defence against log-injection attacks.

#### Scenario: Rejects names containing control or escape characters
- **WHEN** the CLI is invoked with a name containing a control character or escape sequence (e.g. a name with `\x1b[`)
- **THEN** the process exits 2 and stderr contains a message indicating the name contains invalid characters

### Requirement: Emits the greeting within latency budget
A single CLI invocation SHALL complete the greeting construction and presentation
in under 5 ms at p99, measured by a `benchmark-ips` guard in the test suite.

#### Scenario: Emits the greeting in under 5 ms at p99 for a single invocation
- **WHEN** `GreetingService#greet` is called with a valid name and a `FakeClock` in a tight benchmark loop
- **THEN** the p99 wall-clock time per iteration is below 5 ms

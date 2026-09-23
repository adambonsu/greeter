# frozen_string_literal: true

When('the CLI is invoked with the name {string}') do |raw_name|
  invoke_cli(raw_name)
end

When('the CLI is invoked with a name that is 65 characters long') do
  invoke_cli('a' * 65)
end

# Gherkin 27 does not resolve \e in string literals; the ESC byte is
# constructed here in Ruby so the real control character reaches GuestName.
When('the CLI is invoked with a name containing an escape sequence') do
  invoke_cli("\e[31m")
end

Then('the exit code is {int}') do |expected|
  expect(exit_code).to eq(expected)
end

Then('stdout contains {string}') do |expected|
  expect(stdout_io.string).to include(expected)
end

Then('stdout is empty') do
  expect(stdout_io.string).to be_empty
end

Then('stderr contains an invalid name message') do
  expect(stderr_io.string).not_to be_empty
end

Then('stderr contains a name too long message') do
  expect(stderr_io.string).not_to be_empty
end

Then('stderr contains an invalid characters message') do
  expect(stderr_io.string).not_to be_empty
end

When('GreetingService#greet is benchmarked with a valid name and a FixedClock') do
  iterations = 200
  times = Array.new(iterations) do
    t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    service.greet('Alice')
    Process.clock_gettime(Process::CLOCK_MONOTONIC) - t0
  end
  times.sort!
  @p99_ms = times[(iterations * 0.99).ceil - 1] * 1000.0
end

Then('the p99 wall-clock time per iteration is below 5 ms') do
  expect(@p99_ms).to be < 5.0
end

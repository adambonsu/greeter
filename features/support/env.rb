# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(__dir__, "..", "..", "lib"))
$LOAD_PATH.unshift(File.join(__dir__, "..", "..", "spec", "support"))

require "stringio"
require "fixed_clock"
require "greeter/domain/guest_name"
require "greeter/domain/greeting"
require "greeter/domain/greeting_service"
require "greeter/adapters/cli_presenter"

module GreeterWorld
  def stdout_io
    @stdout_io ||= StringIO.new
  end

  def stderr_io
    @stderr_io ||= StringIO.new
  end

  def fixed_clock
    @fixed_clock ||= FixedClock.new(Time.utc(2024, 6, 1, 9, 0, 0))
  end

  def presenter
    @presenter ||= Greeter::Adapters::CliPresenter.new(output: stdout_io)
  end

  def service
    @service ||= Greeter::Domain::GreetingService.new(clock: fixed_clock)
  end

  def invoke_cli(raw_name)
    @exit_code = 0
    service.greet(raw_name).tap { |g| presenter.present(g) }
  rescue Greeter::Domain::InvalidGuestName => e
    @exit_code = 2
    stderr_io.puts(e.message)
  end

  def exit_code
    @exit_code ||= 0
  end
end

World(GreeterWorld)

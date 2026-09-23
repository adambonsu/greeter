# frozen_string_literal: true

require 'greeter/adapters/system_clock'

RSpec.describe Greeter::Adapters::SystemClock do
  subject(:clock) { described_class.new }

  it 'returns a Time instance' do
    expect(clock.now).to be_a(Time)
  end

  it 'returns a UTC time close to now' do
    before = Time.now.utc
    result = clock.now
    after  = Time.now.utc
    expect(result).to be >= before
    expect(result).to be <= after
  end
end

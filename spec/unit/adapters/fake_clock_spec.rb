# frozen_string_literal: true

require 'greeter/adapters/fake_clock'

RSpec.describe Greeter::Adapters::FakeClock do
  let(:fixed_time) { Time.utc(2024, 1, 1, 12, 0, 0) }

  subject(:clock) { described_class.new(fixed_time) }

  it 'returns the fixed time passed at construction' do
    expect(clock.now).to eq(fixed_time)
  end

  it 'returns the same value on repeated calls' do
    expect(clock.now).to eq(clock.now)
  end
end

# frozen_string_literal: true

require 'greeter/domain/guest_name'
require 'greeter/domain/greeting'

RSpec.describe Greeter::Domain::Greeting do
  let(:guest_name) { Greeter::Domain::GuestName.new('Alice') }
  let(:greeted_at) { Time.utc(2024, 6, 1, 9, 0, 0) }

  subject(:greeting) { described_class.new(guest_name: guest_name, greeted_at: greeted_at) }

  # Scenario: Greets a named guest — value object holds the right data
  it 'exposes guest_name' do
    expect(greeting.guest_name).to eq(guest_name)
  end

  it 'exposes greeted_at' do
    expect(greeting.greeted_at).to eq(greeted_at)
  end

  it 'is frozen' do
    expect(greeting).to be_frozen
  end
end

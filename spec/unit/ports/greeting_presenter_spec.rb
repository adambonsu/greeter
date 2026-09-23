# frozen_string_literal: true

require 'greeter/ports/greeting_presenter'

RSpec.describe Greeter::Ports::GreetingPresenter do
  it 'raises NotImplementedError on #present' do
    expect { described_class.new.present(double) }.to raise_error(NotImplementedError)
  end
end

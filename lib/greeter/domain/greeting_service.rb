# frozen_string_literal: true

require 'greeter/domain/guest_name'
require 'greeter/domain/greeting'

module Greeter
  module Domain
    class GreetingService
      def initialize(clock:)
        @clock = clock
      end

      def greet(raw_name)
        Greeting.new(
          guest_name: GuestName.new(raw_name),
          greeted_at: @clock.now
        )
      end
    end
  end
end

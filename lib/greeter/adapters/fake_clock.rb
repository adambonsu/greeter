# frozen_string_literal: true

module Greeter
  module Adapters
    class FakeClock
      def initialize(time)
        @time = time
      end

      def now
        @time
      end
    end
  end
end

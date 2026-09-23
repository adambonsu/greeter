# frozen_string_literal: true

module Greeter
  module Adapters
    class SystemClock
      def now
        Time.now.utc
      end
    end
  end
end

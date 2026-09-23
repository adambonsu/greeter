# frozen_string_literal: true

module Greeter
  module Ports
    class Clock
      def now
        raise NotImplementedError, "#{self.class}#now is not implemented"
      end
    end
  end
end

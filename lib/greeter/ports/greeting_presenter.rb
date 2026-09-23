# frozen_string_literal: true

module Greeter
  module Ports
    class GreetingPresenter
      def present(_greeting)
        raise NotImplementedError, "#{self.class}#present is not implemented"
      end
    end
  end
end

# frozen_string_literal: true

module Greeter
  module Domain
    class Greeting
      attr_reader :guest_name, :greeted_at

      def initialize(guest_name:, greeted_at:)
        @guest_name = guest_name
        @greeted_at = greeted_at
        freeze
      end
    end
  end
end

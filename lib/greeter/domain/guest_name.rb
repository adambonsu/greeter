# frozen_string_literal: true

module Greeter
  module Domain
    class InvalidGuestName < ArgumentError; end

    class GuestName
      MAX_LENGTH = 64

      attr_reader :display

      def initialize(raw)
        validate_characters!(raw.to_s)
        stripped = raw.to_s.strip
        validate_content!(stripped)
        @display = titlecase(stripped)
        freeze
      end

      def ==(other)
        other.is_a?(GuestName) && display == other.display
      end

      private

      def validate_characters!(value)
        raise InvalidGuestName, 'Name contains invalid characters' if value.match?(/[\x00-\x1F\x7F]/)
      end

      def validate_content!(value)
        raise InvalidGuestName, 'Name must not be empty' if value.empty?
        raise InvalidGuestName, "Name must not exceed #{MAX_LENGTH} characters" if value.length > MAX_LENGTH
      end

      def titlecase(value)
        value.split.map(&:capitalize).join(' ')
      end
    end
  end
end

module Portunus
  module TypeCasters
    class DateTime
      def self.cast(value:)
        new(value: value).cast
      end

      def self.uncast(value:)
        new(value: value).uncast
      end

      def initialize(value:)
        @value = value
      end

      def cast
        value.rfc3339
      end

      def uncast
        ::DateTime.rfc3339(value)
      end

      private

      attr_reader :value
    end
  end
end

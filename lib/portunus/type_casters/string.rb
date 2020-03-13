module Portunus
  module TypeCasters
    class String
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
        value.to_s
      end

      def uncast
        value
      end

      private

      attr_reader :value
    end
  end
end

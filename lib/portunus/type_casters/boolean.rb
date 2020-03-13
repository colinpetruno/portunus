module Portunus
  module TypeCasters
    class Boolean
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
        if [false, nil, "false", 0].include?(value)
          "false"
        else
          "true"
        end
      end

      def uncast
        if value == "true"
          true
        elsif value == "false"
          false
        else
          ::Portunus::Error.new("Invalid boolean value")
        end
      end

      private

      attr_reader :value
    end
  end
end

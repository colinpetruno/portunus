module Portunus
  class TypeCaster
    TYPE_MAP = {
      string: ::Portunus::TypeCasters::String,
      integer: ::Portunus::TypeCasters::Integer,
      float: ::Portunus::TypeCasters::Float,
      date:  ::Portunus::TypeCasters::Date,
      datetime: ::Portunus::TypeCasters::DateTime,
      boolean: ::Portunus::TypeCasters::Boolean
    }

    def self.cast(value:, type: nil)
      new(value: value, type: type).cast
    end

    def self.uncast(value:, type: nil)
      new(value: value, type: type).uncast
    end

    def initialize(value:, type: :string)
      @value = value
      @type = type
    end

    def cast
      TYPE_MAP[type.to_sym].cast(value: value)
    end

    def uncast
      TYPE_MAP[type.to_sym].uncast(value: value)
    end

    private

    attr_reader :type, :value
  end
end

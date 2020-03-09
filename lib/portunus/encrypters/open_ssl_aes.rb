module Portunus
  module Encrypters
    class OpenSslAes
      def self.encrypt(key:, value:)
        new(key: key, value: value).encrypt
      end

      def self.decrypt(key:, value:)
        new(key: key, value: value).decrypt
      end

      def initialize(key:, value:)
        @key = key
        @value = value
      end

      def encrypt
        AES.encrypt(value, key)
      end

      def decrypt
        AES.decrypt(value, key)
      end

      private

      attr_reader :key, :value
    end
  end
end

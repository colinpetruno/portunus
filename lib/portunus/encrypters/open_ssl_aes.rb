module Portunus
  module Encrypters
    class OpenSslAes
      def self.encrypt(key:, value:)
        new(key: key, value: value).encrypt
      end

      def self.generate_key
        cipher = OpenSSL::Cipher::AES256.new :CBC
        cipher.encrypt
        Base64.strict_encode64(cipher.random_key)
      end

      def self.decrypt(key:, value:)
        new(key: key, value: value).decrypt
      end

      def initialize(key:, value:)
        @key = Base64.strict_decode64(key)
        @value = value
      end

      def encrypt
        cipher = OpenSSL::Cipher::AES256.new :CBC
        cipher.encrypt
        iv = cipher.random_iv

        cipher.key = key
        cipher.iv = iv

        encrypted_output = cipher.update(value) + cipher.final

        [
          Base64.strict_encode64(iv),
          Base64.strict_encode64(encrypted_output)
        ].join("$")
      end

      def decrypt
        iv, encrypted_text = value.split("$")

        decipher = OpenSSL::Cipher::AES256.new :CBC
        decipher.decrypt

        decipher.iv = Base64.strict_decode64(iv) # previously saved
        decipher.key = key

        output = decipher.update(Base64.strict_decode64(encrypted_text)) + decipher.final

        output
      end

      private

      attr_reader :key, :value
    end
  end
end

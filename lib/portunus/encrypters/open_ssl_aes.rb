module Portunus
  module Encrypters
    class OpenSslAes
      def self.encrypt(key:, value:)
        new(key: key, value: value).encrypt
      end

      def self.generate_key
        cipher = OpenSSL::Cipher::AES256.new :CBC
        cipher.encrypt
        cipher.random_key
      end

      def self.decrypt(key:, value:)
        new(key: key, value: value).decrypt
      end

      def initialize(key:, value:)
        @key = key
        @value = value
      end

      def encrypt
        cipher = OpenSSL::Cipher::AES256.new :CBC
        cipher.encrypt
        cipher.padding = 0
        iv = cipher.random_iv

        cipher.key = key
        cipher.iv = iv

        cipher_text = cipher.update(value) + cipher.final

        [
          Base64.strict_encode64(iv),
          Base64.strict_encode64(cipher_text)
        ].join("$")
      end

      def decrypt
        iv, encrypted_text = value.split("$")

        decipher = OpenSSL::Cipher::AES256.new :CBC
        decipher.decrypt
        decipher.padding = 0

        decipher.iv = Base64.strict_decode64(iv) # previously saved
        decipher.key = key

        decipher.update(Base64.strict_decode64(encrypted_text)) + decipher.final
      rescue StandardError => error
        binding.pry
      end

      private

      attr_reader :key, :value

      def algorithm
        "AES-256-CBC"
      end

      def meh
        aes = OpenSSL::Cipher.new(alg)
        aes.encrypt
        aes.key = key
        aes.iv = iv
      end

      # key = OpenSSL::Cipher::Cipher.new(alg).random_key
      # iv = OpenSSL::Cipher::Cipher.new(alg).random_iv

    end
  end
end

require "spec_helper"

describe Portunus::DataKeyGenerator do
  class DataKeyGeneratorMock
    def generate
      ::Portunus::DataEncryptionKey.new
    end
  end

  let (:user) { User.new }

  describe ".generate" do
    it "should instantiate the class and call generate" do
      mock = DataKeyGeneratorMock.new

      expect(::Portunus::DataKeyGenerator).
        to receive(:new).
        with(object: user).
        and_return(mock)

      expect(mock).to receive(:generate).once

      ::Portunus::DataKeyGenerator.generate(user)
    end
  end

  describe "#generate" do
    class EncrypterMock
      def self.encrypt(key:, value:)
        "iv$encryptedtext"
      end

      def self.decrypt(key:, value:)
        "decryptedtext"
      end

      def self.generate_key
        Base64.strict_encode64("decryptedtext")
      end
    end

    class KeyFinderMock
      def self.random
        "decryptedtext"
      end

      def self.lookup(keyname)
        MasterKey.new(name: keyname, value: "decryptedtext", enabled: true)
      end
    end


    it "should return a valid dek" do
      key = ::Portunus::DataKeyGenerator.generate(user)

      expect(key.class.name.to_s).to eql("Portunus::DataEncryptionKey")
      expect(key.valid?).to eql(true)
    end

    it "calls the encrypter to encrypt the key" do
      generator = ::Portunus::DataKeyGenerator.new(
        object: user
      )

      master_key = generator.send(:master_encryption_key)
      plaintext_key = generator.send(:new_plaintext_key)

      encrypted_result = ::Portunus::Encrypters::OpenSslAes.encrypt(
        key: master_key.value,
        value: plaintext_key
      )

      expect(::Portunus::Encrypters::OpenSslAes).
        to receive(:encrypt).
        with(key: master_key.value, value: plaintext_key).
        and_return(encrypted_result)

      generator.generate
    end

    it "calls the encrypter to generate a key" do
      expect(::Portunus::Encrypters::OpenSslAes).
        to receive(:generate_key).
        and_return(::Portunus::Encrypters::OpenSslAes.generate_key)

      ::Portunus::DataKeyGenerator.new(
        object: user
      ).generate
    end

    it "will raise an error if encrypting the key fails" do
      user = User.new
      generator = ::Portunus::DataKeyGenerator.new(
        object: user
      )
      master_key = generator.send(:master_encryption_key)
      encrypted_key = ::Portunus::Encrypters::OpenSslAes.encrypt(
        key: master_key.value,
        value: ::Portunus.configuration.encrypter.generate_key
      )

      # mock this to ensure the key is not the same one as the generator
      expect(user).
        to receive(:build_data_encryption_key).
        and_return(::Portunus::DataEncryptionKey.new(
          encryptable: user,
          master_keyname: master_key,
          encrypted_key: encrypted_key
        ))

      expect {
        ::Portunus::DataKeyGenerator.generate(user)
      }.to raise_error(::Portunus::Error)
    end
  end
end

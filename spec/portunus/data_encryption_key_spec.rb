require "spec_helper"

describe ::Portunus::DataEncryptionKey do
  describe "#key" do
    it "should attempt to decrypt the key" do
      class MockEncrypter
        def self.decrypt(key:, value:)
          true
        end
      end

      Portunus.configuration do |config|
        config.encrypter = MockEncrypter
      end

      expect(::Portunus.configuration.encrypter).to receive(:decrypt)

      dek = ::Portunus::DataEncryptionKey.new(
        encrypted_key: "asdf",
        master_keyname: ::Portunus.configuration.master_key_names.sample
      )

      dek.key
    end
  end
end

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

  describe "#master_keyname=" do
    it "should break memoization" do
      user = User.create(
        email: "pfluffy@example.com",
        firstname: "Pascal",
        lastname: "Fluffy"
      )

      dek = user.data_encryption_key
      dek.key # force the key to load

      expect(dek.instance_variable_get("@_master_encryption_key")).to_not be_nil
      dek.master_keyname = "fake-key"
      expect(dek.instance_variable_get("@_master_encryption_key")).to be_nil
    end
  end
end

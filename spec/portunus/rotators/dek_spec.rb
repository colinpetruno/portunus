require "spec_helper"

describe ::Portunus::Rotators::Dek do
  describe ".for" do
    it "should instantiate the class and call rotate" do
      data_encryption_key = ::Portunus::DataEncryptionKey.new(
        master_keyname: "fake-key"
      )

      rotator = Portunus::Rotators::Dek.new(data_encryption_key)

      expect(rotator).to receive(:rotate)
      expect(Portunus::Rotators::Dek).to receive(:new).and_return(rotator)

      Portunus::Rotators::Dek.for(data_encryption_key)
    end
  end

  describe "#rotate" do
    it "should do something" do
      user = User.create(
        email: "pfluffy@example.com",
        firstname: "Pascal",
        lastname: "Fluffy"
      )

      expect(user.persisted?).to eql(true)

      data_encryption_key = user.data_encryption_key
      original_dek_key = data_encryption_key.key.dup

      expect(data_encryption_key.last_dek_rotation).to eql(nil)

      ::Portunus::Rotators::Dek.for(data_encryption_key)

      current_key = data_encryption_key.reload.key
      expect(original_dek_key != current_key).to eql(true)
      expect(data_encryption_key.last_dek_rotation).to_not be_nil
    end

    it "will raise a portunus error if something goes wrong" do
      class FakeKey
        def encryptable
          nil
        end

        def destroy
          raise StandardError.new()
        end
      end

      data_encryption_key = FakeKey.new


      expect{::Portunus::Rotators::Dek.for(data_encryption_key)}.
        to raise_error(Portunus::Error)
    end

    it "should delete unused keys" do
      data_encryption_key = ::Portunus::DataEncryptionKey.new

      expect(data_encryption_key).to receive(:destroy).and_return(true)

      ::Portunus::Rotators::Dek.for(data_encryption_key)
    end
  end
end

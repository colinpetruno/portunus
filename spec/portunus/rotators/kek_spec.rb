require "spec_helper"

describe Portunus::Rotators::Kek do
  describe ".for" do
    it "should instantiate a class and call rotate" do
      user = User.create(
        email: "pfluffy@example.com",
        firstname: "Pascal",
        lastname: "Fluffy"
      )

      dek = user.data_encryption_key

      rotator = Portunus::Rotators::Kek.new(dek)
      expect(rotator).to receive(:rotate)
      expect(Portunus::Rotators::Kek).to receive(:new).and_return(rotator)

      Portunus::Rotators::Kek.for(dek)
    end
  end

  describe "#rotate" do
    it "should apply a new master key and keep the unencrypted key the same" do
      user = User.create(
        email: "pfluffy@example.com",
        firstname: "Pascal",
        lastname: "Fluffy"
      )

      dek = user.data_encryption_key
      original_key = dek.key
      original_master_key = dek.master_keyname

      expect(dek.last_kek_rotation).to be_nil

      Portunus::Rotators::Kek.for(dek)

      expect(dek.last_kek_rotation).to_not be_nil
      expect(original_master_key != dek.master_keyname).to eql(true)
      expect(dek.key == original_key).to eql(true)
    end
  end
end

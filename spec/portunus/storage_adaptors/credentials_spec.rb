require "spec_helper"

describe ::Portunus::StorageAdaptors::Credentials do
  describe ".for" do
    it "should call lookup" do
      user = User.new(
        email: "pascal@example.com",
        firstname: "Pascal",
        lastname: "Fluffy"
      )

      data_encryption_key = user.data_encryption_key

      expect(::Portunus::StorageAdaptors::Credentials).
        to receive(:lookup).
        with(data_encryption_key.master_keyname)

      ::Portunus::StorageAdaptors::Credentials.for(data_encryption_key)
    end
  end

  describe ".lookup" do
    it "should find the correct key and load its details into a class" do
      master_key = ::Portunus::StorageAdaptors::Credentials.lookup(
        "65656a18ebf0b4d235c332590480ff04".to_sym
      )

      expect(master_key.class.name).to eql("Portunus::MasterKey")
      expect(master_key.value).to eql(
        "8UizRrhpn9YQJmNXsKJyLwh+anPsb59Og5LqkfApb2A="
      )
    end
  end


  describe ".list" do
    it "should list only active keys" do
      adaptor = ::Portunus::StorageAdaptors::Credentials
      expect(adaptor.list.class).to eql(Array)
      expect(adaptor.list.length).to eql(5)
    end

    it "should raise an error if there are no configured keys" do
      adaptor = ::Portunus::StorageAdaptors::Credentials
      expect(Rails.application.credentials).
        to receive(:portunus).
        and_return({})

      expect{adaptor.list}.to raise_error(Portunus::Error)
    end
  end
end

require "spec_helper"

describe ::Portunus::StorageAdaptors::Credentials do
  describe ".for" do
    it "should instantiate the object and call find" do
      user = User.new(
        email: "pascal@example.com",
        firstname: "Pascal",
        lastname: "Fluffy"
      )

      data_encryption_key = user.data_encryption_key

      mock = ::Portunus::StorageAdaptors::Credentials.new(
        data_encryption_key
      )

      expect(::Portunus::StorageAdaptors::Credentials).
        to receive(:new).
        and_return(mock)

      expect(mock).to receive(:find)

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
  end

  describe "#find" do
  end
end

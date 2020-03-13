require "spec_helper"

describe Portunus::MasterKey do
  describe ".load" do
    it "should load the keys from the storage adaptor" do
      expect(::Portunus.configuration.storage_adaptor).to receive(:load)

      ::Portunus::MasterKey.load
    end
  end


  describe ".lookup" do
    it "looks up a key from the storage adaptor" do
      expect(::Portunus.configuration.storage_adaptor).
        to receive(:lookup).
        with("pascals_key_name")

      ::Portunus::MasterKey.lookup("pascals_key_name")
    end
  end
end

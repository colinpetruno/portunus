require "spec_helper"

describe Portunus::StorageAdaptors::Environment do
  # Other tests rely on the storage credentials adaptor, set it back to ensure
  # other tests aren't effected when running in parallel or randomly
  after(:each) do
    Portunus.configure do |config|
      config.storage_adaptor = ::Portunus::StorageAdaptors::Credentials
    end
  end

  before(:each) do
    Portunus.configure do |config|
      config.storage_adaptor = ::Portunus::StorageAdaptors::Environment
    end
  end

  describe ".for" do
    it "should call lookup" do
      dek = ::Portunus::DataEncryptionKey.new(master_keyname: "keyname")
      adaptor = ::Portunus.configuration.storage_adaptor

      expect(adaptor).to receive(:lookup).with("keyname")

      adaptor.for(dek)
    end
  end

  describe ".key_map" do
    it "should return a hash of the keys" do
      EnvironmentConfiguration.configure
      adaptor = ::Portunus.configuration.storage_adaptor
      expect(adaptor.key_map).to eql({})
      adaptor.load

      expect(adaptor.key_map.keys.length).to eql(6)
    end
  end

  describe ".load" do
    it "should generate the correct keymap" do
      EnvironmentConfiguration.configure
      adaptor = ::Portunus.configuration.storage_adaptor
      adaptor.load
      key = "696c7cd4c58705944385".to_sym
      key_value = "I8dU+Sfipw2PSNW03Oovl39uWFKcveFmfcPnZt+CmEo="

      output = adaptor.key_map[key]

      expect(output[:KEY]).to eql(key_value)
      expect(output[:ENABLED]).to eql("false")
      expect(output[:CREATED]).to eql("2020-03-15T08:58:04+01:00")
    end

    it "should raise an error on failure" do
      EnvironmentConfiguration.configure
      adaptor = ::Portunus.configuration.storage_adaptor

      # Force a function to error to test the rescue and reraise
      expect(adaptor).
        to receive(:key_map).
        and_raise(StandardError.new("error"))

      expect{ adaptor.load }.to raise_error(Portunus::Error)
    end

    it "should return true on success" do
      EnvironmentConfiguration.configure
      adaptor = ::Portunus.configuration.storage_adaptor
      expect(adaptor.load).to eql(true)
    end
  end

  describe ".lookup" do
    it "should return the proper master key" do
      EnvironmentConfiguration.configure
      adaptor = ::Portunus.configuration.storage_adaptor
      adaptor.load
      key = "696c7cd4c58705944385".to_sym
      key_value = "I8dU+Sfipw2PSNW03Oovl39uWFKcveFmfcPnZt+CmEo="

      master_key = adaptor.lookup(key)

      expect(master_key.class).to eql(Portunus::MasterKey)
      expect(master_key.name).to eql(key)
      expect(master_key.value).to eql(key_value)
      expect(master_key.enabled).to eql("false")
      expect(master_key.created_at).to eql("2020-03-15T08:58:04+01:00")
    end

    it "should return an error if it is not found" do
      adaptor = ::Portunus.configuration.storage_adaptor

      expect{ adaptor.lookup("fake-key-name") }.to raise_error(Portunus::Error)
    end
  end

  describe ".list" do
    it "should return all the enabled keynames" do
      EnvironmentConfiguration.configure

      adaptor = ::Portunus.configuration.storage_adaptor
      adaptor.load

      expect(adaptor.list.length).to eql(4)
    end

    it "should raise an error if there are no enabled keys" do
      EnvironmentConfiguration.reset
      adaptor = ::Portunus.configuration.storage_adaptor
      adaptor.reset_key_map

      expect{adaptor.list}.to raise_error(::Portunus::Error)
    end
  end
end

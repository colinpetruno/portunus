require "spec_helper"

describe ::Portunus::Configuration do
  describe ".new" do
    it "should be initialized with defaults" do
      config = ::Portunus.configuration
      config.reload_master_keys

      expect(config.storage_adaptor).to eql(::Portunus::StorageAdaptors::Credentials)
      expect(config.encrypter).to eql(::Portunus::Encrypters::OpenSslAes)
      expect(config.max_key_duration).to eql(6.months)
      expect(config.master_key_names.length).to eql(6)
    end
  end

  describe "#load_keys" do
    it "should call the proper adaptor" do
      config = ::Portunus.configuration

      expect(::Portunus::StorageAdaptors::Credentials).to receive(:load)

      config.load_keys

      expect(config.keys_loaded?).to eql(true)
    end
  end

  describe "#add_key" do
    it "should add the key for selection" do
      config = ::Portunus.configuration
      config.reload_master_keys

      expect(config.master_key_names.length).to eql(6)
      config.add_key(:pascals_key)
      expect(config.master_key_names.include?(:pascals_key)).to eql(true)
      expect(config.master_key_names.length).to eql(7)
    end
  end

  describe "#master_key_names" do
    it "loads the keys if not loaded" do
      config = ::Portunus.configuration
      config.reset_master_keys
      expect(config.master_key_names.length).to eql(6)
    end
  end

  describe "#reset_master_keys" do
    it "should clear all master key names" do
      config = ::Portunus.configuration
      config.reset_master_keys

      expect(config.instance_variable_get(:@master_key_names).length).to eql(0)
      expect(config.instance_variable_get(:@keys_loaded)).to eql(false)
    end
  end

  describe "#reload_master_keys" do
    it "should clear and reset the keys" do
      config = ::Portunus.configuration
      config.reload_master_keys
      config.add_key(:delete_me_key)
      expect(config.instance_variable_get(:@master_key_names).length).to eql(7)
      config.reload_master_keys

      has_key_in_key_names = config.
        instance_variable_get(:@master_key_names).
        include?(:delete_me_key)

      expect(config.instance_variable_get(:@master_key_names).length).to eql(6)
      expect(config.instance_variable_get(:@keys_loaded)).to eql(true)
      expect(has_key_in_key_names).to eql(false)
    end
  end
end

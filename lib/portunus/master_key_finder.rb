module Portunus
  class MasterKeyFinder
    def self.list
      # this function is to get a list of all master keys available to
      # the application
      Portunus.configuration.storage_adaptor.list
    end

    def self.random
      self.list.sample
    end

    def self.lookup(key_name)
      Portunus.configuration.storage_adaptor.lookup(key_name)
    end

    def initialize(data_encryption_key)
      @data_encryption_key = data_encryption_key
    end

    private

    attr_reader :data_encryption_key

    def list_keys
    end
  end
end

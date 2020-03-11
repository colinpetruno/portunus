module Portunus
  class Configuration
    attr_reader :master_key_names, :storage_adaptor, :encrypter,
                :max_key_duration

    def initialize
      @storage_adaptor = ::Portunus::StorageAdaptors::Credentials
      @encrypter = ::Portunus::Encrypters::OpenSslAes
      @keys_loaded = false
      @master_key_names = []
      @max_key_duration = 1.month
    end

    def load_keys
      storage_adaptor.load
      @keys_loaded = true
    end

    def add_key(key_name)
      @master_key_names.push(key_name)
      # we want to load all the names of the keys in the storage
      # adaptor. Because we might need to search through an environment
      # that has quite a few keys often for every key we want to load
      # the valid keys
    end

    def keys_loaded?
      @keys_loaded
    end
  end
end

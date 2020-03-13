module Portunus
  class Configuration
    attr_reader :storage_adaptor, :encrypter, :max_key_duration

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

    def reset_master_keys
      # Clear all master keys to empty, used for testing
      @master_key_names = []
      @keys_loaded = false
    end

    def reload_master_keys
      # Perform a reload on the master keys. This is used in tests and to
      # add new keys into the environment without rebooting the app.
      @master_key_names = []
      load_keys
    end

    def master_key_names
      load_keys unless keys_loaded?

      @master_key_names
    end
  end
end

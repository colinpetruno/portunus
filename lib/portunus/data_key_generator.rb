module Portunus
  class DataKeyGenerator
    def self.generate(object)
      new(object).generate
    end

    def initialize(object)
      @object = object
    end

    def generate
      object.build_data_encryption_key(
        encrypted_key: encrypted_key,
        master_keyname: master_keyname,
        encryptable: object
      )
    end

    private

    attr_reader :object

    def encrypted_key
      encrypted_key_l = ::Portunus.configuration.encrypter.encrypt(
        key: new_key, value: master_encryption_key.value
      )
      encrypted_key_l
    end

    def new_key
      new_key_l = ::Portunus.configuration.encrypter.generate_key
      new_key_l
    end

    def master_keyname
      @_master_keyname ||= ::Portunus::MasterKeyFinder.random
    end

    def master_encryption_key
      @_master_encryption_key = ::Portunus::MasterKeyFinder.
        lookup(master_keyname)
    end
  end
end

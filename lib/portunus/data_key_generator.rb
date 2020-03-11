module Portunus
  class DataKeyGenerator
    def self.generate(object)
      new(object).generate
    end

    def initialize(object)
      @object = object
    end

    def generate
      l_key = new_key

      l_encrypted_key = ::Portunus.configuration.encrypter.encrypt(
        key: master_encryption_key.value,
        value: l_key
      )

      dek = object.build_data_encryption_key(
        encrypted_key: l_encrypted_key,
        master_keyname: master_keyname,
        encryptable: object
      )

      if dek.key != l_key
        raise ::Portunus::Error.new(
          "Dek Key creation failed: Decrypted key does not match the original"
        )
      end

      dek
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
      ::Portunus.configuration.encrypter.generate_key
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

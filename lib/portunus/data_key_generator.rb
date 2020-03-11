module Portunus
  class DataKeyGenerator
    def self.generate(object)
      new(object: object).generate
    end

    def initialize(
      object:,
      encrypter: ::Portunus.configuration.encrypter,
      key_finder: ::Portunus::MasterKeyFinder
    )
      @encrypter = encrypter
      @key_finder = key_finder
      @object = object
    end

    def generate
      dek = object.build_data_encryption_key(
        encrypted_key: new_encrypted_key,
        master_keyname: master_keyname,
        encryptable: object
      )

      if dek.key != new_plaintext_key
        raise ::Portunus::Error.new(
          "Dek Key creation failed: Decrypted key does not match the original"
        )
      end

      dek
    end

    private

    attr_reader :object, :encrypter, :key_finder

    def new_encrypted_key
      @_new_encrypted_key ||= encrypter.encrypt(
        key: master_encryption_key.value, value: new_plaintext_key
      )
    end

    def new_plaintext_key
      # this will be a base64 encoded key
      @_new_key ||= encrypter.generate_key
    end

    def master_keyname
      @_master_keyname ||= key_finder.random
    end

    def master_encryption_key
      @_master_encryption_key = key_finder.lookup(master_keyname)
    end
  end
end

module Portunus
  class DataEncryptionKey < ::ActiveRecord::Base
    belongs_to :encryptable, polymorphic: true

    def key
      ::Portunus.configuration.encrypter.decrypt(
        key: master_encryption_key.value,
        value: encrypted_key
      )
    end

    private

    def master_encryption_key
      @_master_encryption_key ||= Portunus.configuration.storage_adaptor.lookup(
        master_keyname.to_sym
      )
    end
  end
end

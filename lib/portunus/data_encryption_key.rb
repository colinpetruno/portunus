module Portunus
  class DataEncryptionKey < ::ActiveRecord::Base
    belongs_to :encryptable, polymorphic: true

    def key
      AES.decrypt(encrypted_key, master_encryption_key.value)
    end

    private

    def master_encryption_key
      @_master_encryption_key ||= ::Portunus::MasterKeyFinder.lookup(
        master_keyname.to_sym
      )
    end
  end
end

module Portunus
  module Rotators
    class Kek
      def self.for(data_encryption_key)
        new(data_encryption_key).rotate
      end

      def initialize(data_encryption_key)
        @data_encryption_key = data_encryption_key
        @unencrypted_dek = data_encryption_key.key
      end

      def rotate
        data_encryption_key.master_keyname = new_master_key_name
        data_encryption_key.encrypted_key = encrypted_dek_with_new_master
        data_encryption_key.last_kek_rotation = DateTime.now
        data_encryption_key.save!
      end

      private

      attr_reader :data_encryption_key, :unencrypted_dek

      def encrypted_dek_with_new_master
        Portunus.configuration.encrypter.encrypt(
          key: new_master_key.value,
          value: unencrypted_dek
        )
      end

      def new_master_key
        @_new_master_key ||= ::Portunus.configuration.storage_adaptor.lookup(
          new_master_key_name.to_sym
        )
      end

      def wrapped_current_master_key
        [data_encryption_key.master_keyname]
      end

      def master_keys
        Portunus.configuration.storage_adaptor.list
      end

      def new_master_key_name
        @_new_master_key_name ||= (master_keys - wrapped_current_master_key).
          sample
      end
    end
  end
end

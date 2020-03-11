module Portunus
  module Rotators
    class Kek
      def self.for(data_encryption_key)
        new(data_encryption_key).rotate
      end

      def rotate
        data_encryption_key.update(
          master_keyname: new_master_key,
          encrypted_key:
          last_dek_rotation: DateTime.now
        )
        # find new master encryption key
        # unencrypt the dek
        # reencrypt dek with new master key
        # save record
      end

      private

      attr_reader :data_encryption_key

      def original_key
        @_original_key ||= data_encryption_key.key
      end

      def new_master_key
        @_new_master_key ||= ::Portunus::MasterKeyFinder.lookup(
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

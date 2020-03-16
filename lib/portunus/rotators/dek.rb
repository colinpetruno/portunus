module Portunus
  module Rotators
    class Dek
      def self.for(data_encryption_key)
        new(data_encryption_key).rotate
      end

      def initialize(data_encryption_key)
        @data_encryption_key = data_encryption_key
      end

      def rotate
        encryptable = data_encryption_key.encryptable

        encryptable.class.encrypted_fields_list.map do |field_name|
          field_value_map[field_name.to_sym] = encryptable.send(field_name.to_sym)
        end

        data_encryption_key.encrypted_key = new_encrypted_key

        field_value_map.map do |field_name, value|
          encryptable.send("#{field_name}=".to_sym, value)
        end

        ActiveRecord::Base.transaction do
          encryptable.save
          data_encryption_key.last_dek_rotation = DateTime.now
          data_encryption_key.save
        end

        true
      rescue StandardError => error
        raise ::Portunus::Error.new(
          "Rotating DEK failed: #{error.full_message}"
        )
      end

      private

      attr_reader :data_encryption_key

      def storage_adaptor
        ::Portunus.configuration.storage_adaptor
      end

      def encrypter
        ::Portunus.configuration.encrypter
      end

      def field_value_map
        @_field_value_map ||= {}
      end

      def master_key
        storage_adaptor.lookup(data_encryption_key.master_keyname)
      end

      def new_plaintext_key
        @_new_plaintext_key ||= encrypter.generate_key
      end

      def new_encrypted_key
        encrypter.encrypt(
          key: master_key.value, value: new_plaintext_key
        )
      end
    end
  end
end

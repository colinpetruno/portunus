module Portunus
  module Encryptable
    extend ActiveSupport::Concern

    class_methods do
      def encrypted_fields_list
        @_encrypted_fields_list ||= []
      end

      def encrypted_fields(*fields)
        fields.map do |field|
          ::Portunus::FieldConfigurer.for(self, field)
        end
      end
    end

    included do
      before_validation :hash_encrypted_fields

      has_one(
        :data_encryption_key,
        as: :encryptable,
        class_name: "::Portunus::DataEncryptionKey"
      )
    end

    private

    def hash_encrypted_fields
      self.class.encrypted_fields_list.each do |field|
        hashed_field_name = "hashed_#{field}".to_sym

        if respond_to?(hashed_field_name)
          write_attribute(
            hashed_field_name,
            ::Portunus::Hasher.for(send(field.to_sym))
          )
        end
      end
    end
  end
end

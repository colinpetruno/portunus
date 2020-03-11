module Portunus
  module Encryptable
    extend ActiveSupport::Concern

    class_methods do
      def encrypted_fields_list
        @_encrypted_fields_list ||= []
      end

      def encrypted_fields(*fields)
        fields.map do |field|
          # Register the field so we can look it up later
          self.encrypted_fields_list << field

          # Override the getter to decrypt it, provides some support for
          # inferring type based on a suffix
          define_method field.to_sym do
            value = read_attribute(field)

            if value.present?
              dek = data_encryption_key
              decrypted_value = ::Portunus.
                configuration.
                encrypter.
                decrypt(value: value, key: dek.key)

              # by naming encrypted fields with their type we can force a
              # conversion to the proper type after it's decrypted.
              if field.to_s.include?("_date")
                Date.parse(decrypted_value)
              else
                decrypted_value
              end
            else
              nil
            end
          end

          # setup a lazy instantiaion of the DEK so that we don't need to worry
          # about building it for every type of model
          define_method :data_encryption_key do
            # this is to determine if a data encryption key is present
            # if not it will lazily create one and fill out the attribute
            # field on the model containing the key
            result = super()

            if result.blank?
              # self here is the model including encryptable. We pass this
              # so we can call the rails build_data_encryption_key on the
              # model and set up polymorphic columns automatically
              dek = ::Portunus::DataKeyGenerator.generate(self)
              dek
            else
              result
            end
          end

          # Override the setter of the field to do the encryption
          define_method "#{field}=" do |value, &block|
            if value.present?
              dek = data_encryption_key

              encrypted_value = ::Portunus.
                configuration.
                encrypter.
                encrypt(value: value, key: dek.key)
            end

            super(encrypted_value)
          end

          define_method "#{field}_before_type_cast" do
            value = super()
            encrypted = self.class.encrypted_fields_list.include?(field.to_sym)

            if encrypted && value.present?
              dek = data_encryption_key
              value = ::Portunus.
                configuration.
                encrypter.
                decrypt(value: value, key: dek.key)
            end

            return value
          end
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

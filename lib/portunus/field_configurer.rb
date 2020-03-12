module Portunus
  class FieldConfigurer
    def self.for(object, field)
      new(object: object, field: field).setup
    end

    def initialize(object:, field:)
      @object = object
      @field = field
    end

    def setup
      # add the field to a configuration so we can easily determine if it's
      # a field we need to attempt to encrypt and decrypt. We need this in
      # the `field_before_typecast` method since the normal accessors are
      # not used after a validation fail
      register_field

      # setup the methods on the model itself
      define_instance_methods
    end

    private

    attr_accessor :field, :object

    def instance_methods_for_model
      [
        :define_getter,
        :define_setter,
        :define_before_type_cast,
        :define_association
      ]
    end

    def define_instance_methods
      instance_methods_for_model.map do |method|
        send(method)
      end
    end

    def define_setter
      # Override the setter of the field to do the encryption
      object.define_method "#{field}=" do |value, &block|
        if value.present?
          dek = data_encryption_key

          encrypted_value = ::Portunus.
            configuration.
            encrypter.
            encrypt(value: value, key: dek.key)
        end

        super(encrypted_value)
      end
    end

    def define_getter
      # This is required to force the proper scope in this context.
      l_field = field

      object.define_method(l_field.to_sym) do
        value = read_attribute(l_field.to_sym)

        if value.present?
          dek = data_encryption_key

          ::Portunus.
            configuration.
            encrypter.
            decrypt(value: value, key: dek.key)
        else
          nil
        end
      end
    end

    def define_before_type_cast
      object.define_method "#{field}_before_type_cast" do
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

    def define_association
      # setup a lazy instantiaion of the DEK so that we don't need to worry
      # about building it for every type of model
      object.define_method :data_encryption_key do
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
    end

    def register_field
      # Register the field so we can look it up later
      object.encrypted_fields_list << field
    end
  end
end

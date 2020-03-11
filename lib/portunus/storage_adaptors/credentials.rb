module Portunus
  module StorageAdaptors
    class Credentials
      def self.for(data_encryption_key)
        new(data_encryption_key).find
      end

      def self.load
        key_names = Rails.application.credentials.config.portunus.keys

        key_names.map do |key_name|
          ::Portunus::Configuration.add_key(key_name)
        end
      end

      # Required method
      def self.lookup(key_name)
        master_key = Rails.application.credentials.portunus[key_name.to_sym]

        MasterKey.new(
          enabled: master_key[:enabled],
          name: key_name,
          value: master_key[:key]
        )
      rescue StandardError
        raise ::Portunus::Error.new("Portunus: Master key not found")
      end

      # Required method
      def self.list
        key_names = Rails.application.credentials.portunus.keys
        # reject any disabled keys so we no longer utilize them for new
        # deks
        key_names.reject! do |key_name|
          Rails.application.credentials.portunus[key_name][:enabled] == false
        end

        if key_names.length == 0
          raise ::Portunus::Error.new("No valid master keys configured")
        end

        key_names
      end

      def initialize(data_encryption_key)
        @data_encryption_key = data_encryption_key
      end

      def find
        Rails.
          application.
          credentials.
          portunus_master_keys[data_encryption_key.master_keyname.to_sym]
      end
    end
  end
end


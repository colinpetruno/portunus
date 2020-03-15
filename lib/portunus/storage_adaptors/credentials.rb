module Portunus
  module StorageAdaptors
    class Credentials
      def self.for(data_encryption_key)
        self.lookup(data_encryption_key.master_keyname)
      end

      def self.load
        key_names = Rails.application.credentials.portunus.keys

        key_names.map do |key_name|
          ::Portunus.configuration.add_key(key_name)
        end
      end

      # Required method
      def self.lookup(key_name)
        master_key = Rails.application.credentials.portunus[key_name.to_sym]

        MasterKey.new(
          enabled: master_key[:enabled],
          name: key_name,
          value: master_key[:key],
          created_at: master_key[:created_at]
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
    end
  end
end


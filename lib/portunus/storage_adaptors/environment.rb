module Portunus
  module StorageAdaptors
    class Environment
      def self.for(data_encryption_key)
        self.lookup(data_encryption_key.master_keyname)
      end

      def self.key_map
        @@key_map ||= {}
      end

      def self.reset_key_map
        @@key_map = {}
      end

      def self.load
        key_names = ENV.keys.select { |key| key.start_with?("PORTUNUS_") }

        key_names.map do |name|
          _portunus, key_name, key_type  = name.split("_")

          if self.key_map[key_name.to_sym].blank?
            self.key_map[key_name.to_sym] = {}
          end

          self.key_map[key_name.to_sym][key_type.to_sym] = ENV.fetch(name)
        end

        true
      rescue StandardError => error
        raise ::Portunus::Error.new(
          "Portunus: Master keys failed to load: #{error.full_message}"
        )
      end

      def self.lookup(key_name)
        master_key = self.key_map[key_name.to_sym]

        MasterKey.new(
          enabled: master_key[:ENABLED],
          name: key_name,
          value: master_key[:KEY],
          created_at: master_key[:CREATED]
        )
      rescue StandardError
        raise ::Portunus::Error.new("Portunus: Master key not found")
      end

      def self.list
        # Select only enabled keys
        key_names = self.key_map.keys.map do |keyname|
          keyname if self.key_map[keyname][:ENABLED] == "true"
        end.compact

        if key_names.length == 0
          raise ::Portunus::Error.new("No valid master keys configured")
        end

        key_names
      end

      private

      attr_reader :data_encryption_key
    end
  end
end

module Portunus
  module MasterKeys
    class EnvironmentAdaptor

      def self.load
        key_names = ENV.keys.select { |key| key.start_with?("PORTUNUS_") }

        key_names.reject do |key_name|
          ENV.keys.include?("#{key_name}_DISABLED")
        end
      end

      def self.lookup
        ENV[data_encryption_key.master_keyname.upcase]
      rescue StandardError
        raise ::Portunus::Error.new("Portunus: Master key not found")
      end

      private

      attr_reader :data_encryption_key
    end
  end
end

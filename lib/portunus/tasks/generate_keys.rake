namespace :portunus do
  desc "Output master keys for use with Portunus"
  task :generate_master_keys do
    adaptor_name = Portunus.configuration.storage_adaptor.to_s

    if adaptor_name == "Portunus::StorageAdaptors::Credentials"
      keys = (0..5).to_a.map do 
        { 
          "key": ::Portunus.configuration.encrypter.generate_key, 
          "enabled": true 
        }
      end

      key_hash = keys.inject({}) do |hash, key|
        hash[SecureRandom.hex(16).to_s] = key
        hash
      end

      puts({ portunus: key_hash }.to_yaml)
    else
      raise ::Portunus::Error.new("Adaptor does not support key generation")
    end
  end
end

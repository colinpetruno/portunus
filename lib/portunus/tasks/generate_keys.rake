namespace :portunus do
  desc "Output master keys for use with Portunus"
  task generate_master_keys: :environment do
    adaptor_name = Portunus.configuration.storage_adaptor.to_s
    puts "Generating keys for adaptor: #{adaptor_name}"

    keys = (0..5).to_a.map do 
      { 
        "key": ::Portunus.configuration.encrypter.generate_key, 
        "enabled": true,
        "created_at": DateTime.now.rfc3339
      }
    end

    if adaptor_name == "Portunus::StorageAdaptors::Credentials"
      key_hash = keys.inject({}) do |hash, key|
        hash[SecureRandom.hex(16).to_s] = key
        hash
      end

      puts({ portunus: key_hash }.to_yaml)
    elsif adaptor_name == "Portunus::StorageAdaptors::Environment" 
      output = ""
      keys.map do |portunus_key|
        key_name = SecureRandom.hex(10)
        output += "export PORTUNUS_#{key_name}_KEY=#{portunus_key[:key]}\n"
        output += "export PORTUNUS_#{key_name}_ENABLED=true\n"
        output += "export PORTUNUS_#{key_name}_CREATED_AT=#{portunus_key[:created_at]}\n"
      end

      puts output
    else
      raise ::Portunus::Error.new("Adaptor does not support key generation")
    end
  end
end

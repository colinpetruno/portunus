namespace :portunus do
  desc "Rotate KEK keys, reencrypt the deks"
  task rotate_keks: :environment do
    scope = ::Portunus::DataEncryptionKey.
      where(
        "last_kek_rotation < ? or (created_at < ? and last_kek_rotation is null", 
        ::Portunus.configuration.max_key_duration,
        ::Portunus.configuration.max_key_duration
      )

    scope.in_batches do |relation|
      relation.map do |encryption_key|
        ::Portunus::Rotators::Kek.for(encryption_key)
      end
    end
  end

  desc "Rotate DEK keys, reencrypt the data"
  task rotate_deks: :environment do
    if ENV["FORCE"] == "true"
      scope = ::Portunus::DataEncryptionKey.all
    else
      scope = ::Portunus::DataEncryptionKey.
        where(
          "last_dek_rotation < ? or (created_at < ? and last_dek_rotation is null", 
          ::Portunus.configuration.max_key_duration,
          ::Portunus.configuration.max_key_duration
        )
    end
    scope.in_batches do |relation|
      relation.map do |encryption_key|
        ::Portunus::Rotators::Dek.for(encryption_key)
      end
    end
  end
end

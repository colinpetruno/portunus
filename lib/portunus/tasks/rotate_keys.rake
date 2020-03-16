namespace :portunus do
  desc "Output master keys for use with Portunus"
  task :rotate_keks do
    # In this task we need to go through each kek and find all it's deks and
    # then rotate those to new, will attempt to rotate keks older than the max
    # key duration

  end

  task :rotate_deks do
    if ENV["FORCE"] == "true"
      scope = ::Portunus::DataEncryptionKey.all
    else
      scope = ::Portunus::DataEncryptionKey.
        where(
          "last_dek_rotation < ? or (created_at < ? and last_dek_rotation is null", 
          ::Portunus.configuration.max_key_duration)
    end
    scope.in_batches do |relation|
      relation.map do |encryption_key|
        ::Portunus::Rotators::Dek.for(encryption_key)
      end
    end
  end
end

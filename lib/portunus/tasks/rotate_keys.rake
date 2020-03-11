namespace :portunus do
  desc "Output master keys for use with Portunus"
  task :rotate_keks do
  end

  task :rotate_deks do
    dek = ::Portunus::DataKeyGenerator.generate(self)
  end

  task :rotate_both do
    ::Portunus::DataEncryptionKey.where().in_batches do |relation|
      relation.map do |encryption_key|

      end
    end
  end
end

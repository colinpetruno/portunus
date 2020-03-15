module Portunus
  class MasterKey
    include ActiveModel::Model

    attr_accessor :name, :value, :enabled, :created_at

    def self.load
      Portunus.configuration.storage_adaptor.load
    end

    def self.lookup(key_name)
      Portunus.configuration.storage_adaptor.lookup(key_name)
    end
  end
end

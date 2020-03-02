module Portunus
  class MasterKey
    include ActiveModel::Model

    attr_accessor :name, :value, :enabled

    def self.load
      Proteus.configuration.storage_adaptor.load
    end

    def self.lookup(key_name)
      Proteus.configuration.storage_adaptor.lookup(key_name)
    end
  end
end

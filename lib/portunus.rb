require "aes"
require "portunus/version"
require "generators/install_generator.rb"
require "portunus/configuration"
require "portunus/data_encryption_key"
require "portunus/encryptable"
require "portunus/data_key_generator"
require "portunus/hasher"
require "portunus/master_key"
require "portunus/master_key_finder"
require "portunus/master_keys/credentials_adaptor"
require "portunus/master_keys/environment_adaptor"


module Portunus
  require "portunus/railtie" if defined?(Rails)
  class Error < StandardError; end
  # Your code goes here...
  def self.configure
    @@configuration ||= ::Portunus::Configuration.new

    yield(@@configuration)
  end

  def self.configuration
    @@configuration ||= ::Portunus::Configuration.new
  end

  def self.table_name_prefix
    "portunus_"
  end
end

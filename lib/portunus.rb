require "portunus/version"
require "generators/install_generator.rb"
require "portunus/configuration"
require "portunus/data_encryption_key"
require "portunus/encryptable"
require "portunus/data_key_generator"
require "portunus/field_configurer"
require "portunus/hasher"
require "portunus/master_key"
require "portunus/rotators/dek"
require "portunus/rotators/kek"
require "portunus/storage_adaptors/credentials"
require "portunus/storage_adaptors/environment"
require "portunus/encrypters/open_ssl_aes"
require "portunus/type_casters/boolean"
require "portunus/type_casters/date"
require "portunus/type_casters/date_time"
require "portunus/type_casters/integer"
require "portunus/type_casters/float"
require "portunus/type_casters/string"
require "portunus/type_caster"

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

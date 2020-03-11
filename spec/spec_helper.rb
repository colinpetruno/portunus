require "bundler/setup"
Bundler.setup

require "rails/all"
require "portunus"
require_relative "./models/user"


# require "dummy/application"
# Dummy::Application.initialize!
#

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "pry-rails"

module Dummy
  class Application < Rails::Application
    config.root = File.join(__dir__, "dummy")
    config.load_defaults Rails::VERSION::STRING.to_f
    config.eager_load = false
    config.credentials.content_path = Rails.root.join("config", "credentials", "test.yml.enc")
    config.credentials.key_path = Rails.root.join("config", "credentials", "test.key")
  end
end

Rails.application.initialize!

RSpec.configure do |config|
end

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

ActiveRecord::Schema.define do
  require_relative "./db/migrate/create_models"
end

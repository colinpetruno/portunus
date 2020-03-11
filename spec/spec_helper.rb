require "bundler/setup"
Bundler.setup

require "rails/all"
require "portunus"
require "aes"


# require "dummy/application"
# Dummy::Application.initialize!

RSpec.configure do |config|
end

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

ActiveRecord::Schema.define do
  require_relative './db/migrate/create_models'
end

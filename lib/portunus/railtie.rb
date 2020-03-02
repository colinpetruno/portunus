# lib/railtie.rb
require "portunus"
require "rails"

module Portunus
  class Railtie < Rails::Railtie
    railtie_name :portunus

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end

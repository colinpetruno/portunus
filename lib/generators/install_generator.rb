require 'rails/generators'
require 'rails/generators/migration'
require "rails/generators/active_record/migration"

module Portunus
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration

      source_root File.expand_path("templates", __dir__)
      desc "Add the migrations for Porteus"

      def copy_migrations
        # options["encryption_engine"]
        warn "Creating Migrations for Portunus Encryption"
        migration_template(
          "create_portunus.rb.erb",
          "db/migrate/create_portunus.rb"
        )
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
      end
    end
  end
end

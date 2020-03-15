require "spec_helper"

describe "Install generator" do
  it "should create the migration file" do
    generator = ::Portunus::Generators::InstallGenerator
    output = generator.start([], destination_root: Rails.root.to_s)
    # Example output:
    # ["db/migrate/20200315103331_create_portunus.rb", "[6.0]"]

    file_path = Rails.root.join(output.first)
    expect(File.exists?(file_path)).to eql(true)

    # clear file for future tests
    File.delete(file_path) if File.exist?(file_path)
  end
end



lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "portunus/version"

Gem::Specification.new do |spec|
  spec.name          = "portunus"
  spec.version       = Portunus::VERSION
  spec.authors       = ["Colin Petruno"]
  spec.email         = ["colinpetruno@gmail.com"]

  spec.summary       = %q{DEK and KEK Encryption for Rails}
  spec.description   = %q{Easily encrypt all your sensitive data.}
  spec.homepage      = "https://www.github.com/colinpetruno/portunus"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = "https://www.github.com/colinpetruno/portunus"
    spec.metadata["source_code_uri"] = "https://www.github.com/colinpetruno/portunus"
    spec.metadata["changelog_uri"] = "https://www.github.com/colinpetruno/portunus/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails", ">= 5.0.0"
  spec.add_runtime_dependency "aes"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rails", ">= 5.0.0"
  spec.add_development_dependency "rake", "> 12.3.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
end

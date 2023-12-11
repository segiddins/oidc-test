# frozen_string_literal: true

require_relative "lib/oidc/test/version"

Gem::Specification.new do |spec|
  spec.name = ENV.fetch("GEMSPEC_NAME", "oidc-test")
  spec.version = Oidc::Test::VERSION
  spec.authors = ["Samuel Giddins"]
  spec.email = ["segiddins@segiddins.me"]

  spec.summary = "Test gem"
  spec.homepage = "https://github.com/segiddins/oidc-test"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = ENV["GEM_HOST"] if ENV["GEM_HOST"]

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

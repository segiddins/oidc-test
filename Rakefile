# frozen_string_literal: true

require "bundler/gem_helper"

module Bundler
  class GemHelper
    prepend(Module.new do
      def install
        super

        namespace :release do
          task attest: :build do
            attest if attest?
          end

          task rubygem_push: :attest
        end
      end

      def build_gem
        @build_gem_path = super
      end

      def rubygem_push(path)
        return super unless attest?

        cmd = [{ "RUBYOPT" => "-r#{File.expand_path("tasks/rubygems_patch.rb", __dir__)} #{ENV["RUBYOPT"]}",
                 "gem_attestation_path" => "#{path}.sigstore.json" }, *gem_command, "push", path]
        cmd << "--key" << gem_key if gem_key
        cmd << "--host" << allowed_push_host if allowed_push_host
        sh_with_input(cmd)
        Bundler.ui.confirm "Pushed #{name} #{version} to #{gem_push_host}"
      end
    end)

    def attest?
      return true if %w[y yes true on 1].include?(ENV["gem_attest"])
      return false if %w[n no nil false off 0].include?(ENV["gem_attest"])

      ENV["ACTIONS_ID_TOKEN_REQUEST_URL"] && ENV["ACTIONS_ID_TOKEN_REQUEST_TOKEN"]
    end

    def attest
      sh [Gem.ruby, "-S", "gem", "install", "sigstore"]
      sh [Gem.ruby, "-rnet/http", "-rsigstore", "-rsigstore/signer", "-e", <<~RUBY, @build_gem_path]
        file = ARGV.first
        jwt = Net::HTTP.get_response(
          URI(ENV.fetch("ACTIONS_ID_TOKEN_REQUEST_URL") + "&audience=sigstore"),
          { "Authorization" => "bearer \#{ENV.fetch("ACTIONS_ID_TOKEN_REQUEST_TOKEN")}" },
          &:value
        ).body.then { JSON.parse(_1).fetch("value") }

        contents = File.binread(file)
        bundle = Sigstore::Signer.new(jwt:, trusted_root: Sigstore::TrustedRoot.production).sign(contents)

        File.binwrite("#{file}.sigstore.json", bundle.to_json)
      RUBY
    end
  end
end

require "bundler/gem_tasks"

Bundler::GemHelper.tag_prefix = ENV["TAG_PREFIX"] if ENV["TAG_PREFIX"]

begin
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec)

  require "rubocop/rake_task"

  RuboCop::RakeTask.new

  task default: %i[spec rubocop]
rescue LoadError
  warn "RSpec or RuboCop not available."
end

# frozen_string_literal: true

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

# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'dotenv'

$LOAD_PATH.unshift File.expand_path('lib', __dir__)

require_relative 'lib/rujira'

Rujira::Tasks::Jira.new

Dotenv.load

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: %i[test spec rubocop]

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
  t.verbose = false
end

task :version do
  puts Rujira::VERSION
end

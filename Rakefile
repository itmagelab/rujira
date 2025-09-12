# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'dotenv'

$LOAD_PATH.unshift File.expand_path('lib', __dir__)

require_relative 'lib/rujira'

Rujira::Tasks::Jira.new

Dotenv.load

task default: %i[test]

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
  t.verbose = false
end

task :version do
  puts Rujira::VERSION
end

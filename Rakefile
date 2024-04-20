# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'rujira'
require 'rujira/tasks/jira'

task default: %i[test]

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
  t.verbose = false
end

Rujira::Tasks::Jira.new

task :version do
  puts Rujira::VERSION
end

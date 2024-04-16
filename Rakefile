# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
task default: %i[test]

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
  t.verbose = false
end

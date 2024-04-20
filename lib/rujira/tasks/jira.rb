# frozen_string_literal: true

require 'rake'
require 'rake/tasklib'
require 'json'

module Rujira
  module Tasks
    # TODO
    class Jira
      include ::Rake::DSL if defined?(::Rake::DSL)

      def initialize
        @options = {}
        @parser = OptionParser.new
        define
      end

      def parser
        yield
        args = @parser.order!(ARGV) {}
        @parser.parse!(args)
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def define
        generate 'whoami' do
          puts Rujira::Api::Myself.get.name
        end
        generate 'url' do
          puts Rujira::Configuration.url
        end
        generate 'server_info' do
          puts Rujira::Api::ServerInfo.get.data.to_json
        end
        generate 'search' do
          parser do
            @parser.banner = "Usage: rake jira:task:search -- '[options]'"
            @parser.on('-q JQL', '--jql JQL') do |jql|
              @options[:jql] = jql
            end
          end

          result = Rujira::Api::Search.get jql: @options[:jql]
          result.iter.each { |i| puts JSON.pretty_generate(i.data) }
        end
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

      def generate(name, &block)
        fullname = "jira:#{name}"
        desc "Run #{fullname}"

        Rake::Task[fullname].clear if Rake::Task.task_defined?(fullname)
        namespace :jira do
          task name do
            instance_eval(&block)
          end
        end
      end
    end
  end
end

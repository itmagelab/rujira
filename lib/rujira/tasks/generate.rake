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
        @options = {
          issuetype: 'Task'
        }
        @parser = OptionParser.new

        apply
      end

      def parser
        yield
        args = @parser.order!(ARGV) {}
        @parser.parse!(args)
      end

      def options(name)
        @options[name]
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/BlockLength
      def apply
        namespace :jira do
          desc 'Test connection by getting username'
          task :whoami do
            puts Rujira::Api::Myself.get
          end

          desc 'Test connection by getting url'
          task :url do
            puts Rujira::Configuration.url
          end

          desc 'Test connection by getting server information'
          task :server_info do
            puts Rujira::Api::ServerInfo.get.data.to_json
          end

          namespace :issue do
            desc 'Create a issue'
            task :create do
              parser do
                @parser.banner = "Usage: rake jira:issue:create -- '[options]'"
                @parser.on('-p PROJECT', '--project=PROJECT') { |project| @options[:project] = project.strip }
                @parser.on('-s SUMMARY', '--summary=SUMMARY') { |summary| @options[:summary] = summary.strip }
                @parser.on('-d DESCRIPTION', '--description=DESCRIPTION') do |description|
                  @options[:description] = description.strip
                end
                @parser.on('-i ISSUETYPE', '--issuetype=ISSUETYPE') do |issuetype|
                  @options[:issuetype] = issuetype.strip
                end
              end

              options = @options
              result = Rujira::Api::Issue.create do
                data fields: {
                  project: { key: options[:project] },
                  summary: options[:summary],
                  issuetype: { name: options[:issuetype] },
                  description: options[:description]
                }
              end
              url = Rujira::Configuration.url
              puts "// A new issue been posted, check it out at #{url}/browse/#{result.data['key']}"
            end

            desc 'Search issue by fields'
            task :search do
              parser do
                @parser.banner = "Usage: rake jira:issue:search -- '[options]'"
                @parser.on('-q JQL', '--jql=JQL') { |jql| @options[:jql] = jql }
              end

              options = @options
              result = Rujira::Api::Search.get do
                data jql: options[:jql]
              end
              result.iter.each { |i| puts JSON.pretty_generate(i.data) }
            end

            desc 'Delete issue'
            task :delete do
              parser do
                @parser.banner = "Usage: rake jira:issue:delete -- '[options]'"
                @parser.on('-i ID', '--issue=ID') { |id| @options[:id] = id }
              end

              Rujira::Api::Issue.del @options[:id]
            end

            desc 'Example usage attaching in issue'
            task :attach do
              parser do
                @parser.banner = "Usage: rake jira:issue:attach -- '[options]'"
                @parser.on('-f FILE', '--file=FILE') { |file| @options[:file] = file }
                @parser.on('-i ID', '--issue=ID') { |id| @options[:id] = id }
              end

              result = Rujira::Api::Issue.attachments @options[:id], @options[:file]
              puts JSON.pretty_generate(result.data)
            end
          end
        end
      end
      # rubocop:enable Metrics/BlockLength
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength
    end
  end
end

Rujira::Tasks::Jira.new

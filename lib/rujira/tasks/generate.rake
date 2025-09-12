# frozen_string_literal: true

require 'rake'
require 'rake/tasklib'
require 'json'

# TODO
module Rujira
  module Tasks
    # TODO
    class Jira # rubocop:disable Metrics/ClassLength
      include Rake::DSL if defined?(Rake::DSL)
      def initialize
        @options = {
          issuetype: 'Task'
        }
        @parser ||= OptionParser.new

        apply
      end

      def parser
        yield
        args = @parser.order!(ARGV)
        @parser.parse!(args)
      end

      def options(name)
        @options[name]
      end

      def client
        @client ||= Rujira::Client.new('http://localhost:8080', debug: true)
      end

      def apply # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
        namespace :jira do # rubocop:disable Metrics/BlockLength
          desc 'Test connection by getting username'
          task :whoami do
            puts client.Myself.get
          end

          desc 'Test connection by getting server information'
          task :server_info do
            puts client.ServerInfo.get
          end

          namespace :dashboard do
            desc 'Get list of dashboards'
            task :list do
              result = client.Dashboard.list
              result['dashboards'].each { |i| puts JSON.pretty_generate(i) }
            end

            desc 'Get a dashboard'
            task :get do
              parser do
                @parser.banner = "Usage: rake jira:dashboard:get -- '[options]'"
                @parser.on('-i ID', '--id=ID') { |id| @options[:id] = id }
              end

              puts Api::Dashboard.get @options[:id]
            end
          end

          namespace :board do
            desc 'Get list of boards'
            task :list do
              result = client.Board.list
              result['values'].each { |i| puts JSON.pretty_generate(i) }
            end

            desc 'Get a board'
            task :get do
              parser do
                @parser.banner = "Usage: rake jira:board:get -- '[options]'"
                @parser.on('-i ID', '--id=ID') { |id| @options[:id] = id }
              end

              puts client.Board.get @options[:id]
            end

            desc 'Get a boards sprint'
            task :sprint do
              parser do
                @parser.banner = "Usage: rake jira:board:sprint -- '[options]'"
                @parser.on('-i ID', '--id=ID') { |id| @options[:id] = id }
              end

              puts client.Board.sprint @options[:id]
            end
          end

          namespace :sprint do
            namespace :properties do
              desc 'Get sprint properties'
              task :list do
                parser do
                  @parser.banner = "Usage: rake jira:board:sprint:properties -- '[options]'"
                  @parser.on('-i ID', '--id=ID') { |id| @options[:id] = id }
                end

                puts client.Sprint.properties @options[:id]
              end
            end
          end

          namespace :issue do # rubocop:disable Metrics/BlockLength
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
              result = client.Issue.create do
                payload fields: {
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
              result = client.Search.get do
                data jql: options[:jql]
              end
              result['issues'].each { |i| puts JSON.pretty_generate(i) }
            end

            desc 'Delete issue'
            task :delete do
              parser do
                @parser.banner = "Usage: rake jira:issue:delete -- '[options]'"
                @parser.on('-i ID', '--issue=ID') { |id| @options[:id] = id }
              end

              client.Issue.del @options[:id]
            end

            desc 'Example usage attaching in issue'
            task :attach do
              parser do
                @parser.banner = "Usage: rake jira:issue:attach -- '[options]'"
                @parser.on('-f FILE', '--file=FILE') { |file| @options[:file] = file }
                @parser.on('-i ID', '--issue=ID') { |id| @options[:id] = id }
              end

              result = client.Issue.attachments @options[:id], @options[:file]
              puts JSON.pretty_generate(result)
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'rake'
require 'rake/tasklib'
require 'json'

# TODO
module Rujira
  module Tasks
    # TODO
    class Jira
      include Rake::DSL if defined?(Rake::DSL)
      def initialize
        generate
      end

      def client
        @client ||= Rujira::Client.new('http://localhost:8080', debug: false)
      end

      def fetch_options(params, name)
        help = params.map { |k| "#{k}=<VALUE>" }.join(' ')
        options = params.to_h do |k|
          [k.downcase.to_sym, ENV.fetch(k, nil)]
        end
        missing = options.select { |_, v| v.nil? }.keys
        unless missing.empty?
          abort "❌ ERROR: The following required environment variables are missing: #{missing.join(', ').upcase}\n" \
                "✅ USAGE: rake #{name} #{help}"
        end

        options
      end

      def generate # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
        namespace :jira do
          desc 'Test connection by getting username'
          task :whoami do
            result = client.Myself.get
            puts JSON.pretty_generate(result)
          end

          desc 'Test connection by getting server information'
          task :server_info do
            result = client.ServerInfo.get
            puts JSON.pretty_generate(result)
          end

          namespace :project do
            desc 'Get list of projects'
            task :list do
              result = client.Project.list
              puts JSON.pretty_generate(result)
            end
          end

          namespace :dashboard do
            desc 'Get list of dashboards'
            task :list do
              result = client.Dashboard.list
              result['dashboards'].each { |i| puts JSON.pretty_generate(i) }
            end

            desc 'Get a dashboard'
            task :get do |t|
              options = fetch_options(%w[DASHBOARD_ID], t.name)

              result = client.Dashboard.get options[:dashboard_id]
              puts JSON.pretty_generate(result)
            end
          end

          namespace :board do
            desc 'Get list of boards'
            task :list do
              result = client.Board.list
              result['values'].each { |i| puts JSON.pretty_generate(i) }
            end

            desc 'Get a board'
            task :get do |t|
              options = fetch_options(%w[BOARD_ID], t.name)

              result = client.Board.get options[:board_id]
              puts JSON.pretty_generate(result)
            end

            desc 'Get a boards sprint'
            task :sprint do |t|
              options = fetch_options(%w[BOARD_ID], t.name)

              result = client.Board.sprint options[:board_id]
              puts JSON.pretty_generate(result)
            end
          end

          namespace :sprint do
            namespace :properties do
              desc 'Get sprint properties'
              task :list do |t|
                options = fetch_options(%w[BOARD_ID], t.name)

                result = client.Sprint.properties options[:board_id]
                puts JSON.pretty_generate(result)
              end
            end
          end

          namespace :issue do
            desc 'Create a issue'
            task :create do |t|
              options = fetch_options(%w[PROJECT SUMMARY DESCRIPTION ISSUETYPE], t.name)
              abort 'ISSUETYPE must start with a capital letter' unless options[:issuetype].match?(/\A[A-Z]/)

              result = client.Issue.create do
                payload fields: {
                  project: { key: options[:project] },
                  summary: options[:summary],
                  issuetype: { name: options[:issuetype] },
                  description: options[:description]
                }
              end
              puts JSON.pretty_generate(result)
            end

            desc 'Search issue by fields'
            task :search do |t|
              options = fetch_options(%w[JQL], t.name)
              result = client.Search.get do
                data jql: options[:jql]
              end
              result['issues'].each { |i| puts JSON.pretty_generate(i) }
            end

            desc 'Delete issue'
            task :delete do |t|
              options = fetch_options(%w[ISSUE_ID], t.name)

              client.Issue.del options[:issue_id]
            end

            desc 'Example usage attaching in issue'
            task :attach do |t|
              options = fetch_options(%w[FILE ISSUE_ID], t.name)

              result = client.Issue.attachments options[:issue_id], @options[:file]
              puts JSON.pretty_generate(result)
            end
          end
        end
      end
    end
  end
end

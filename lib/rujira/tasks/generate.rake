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
      require_relative 'utils'

      def initialize
        generate
      end

      def generate # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
        namespace :jira do # rubocop:disable Metrics/BlockLength
          require_relative 'issue'

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

            desc 'Create project'
            task :create do |t|
              options = fetch_options(%w[KEY NAME TYPE LEAD], t.name)
              result = client.Project.create do
                payload key: options[:key],
                        name: options[:name],
                        projectTypeKey: options[:type],
                        lead: options[:lead]
              end
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
        end
      end
    end
  end
end

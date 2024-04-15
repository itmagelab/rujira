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
        define
      end

      def define
        whoami
        url
        server_info
      end

      def whoami
        name = __method__
        desc 'Request my real name in Jira'

        Rake::Task[name].clear if Rake::Task.task_defined?(name)
        namespace :jira do
          task name do
            puts Rujira::Api::Myself.get.name
          end
        end
      end

      def url
        name = __method__
        desc 'Request server url from Jira'

        Rake::Task[name].clear if Rake::Task.task_defined?(name)
        namespace :jira do
          task name do
            puts Rujira::Configuration.url
          end
        end
      end

      def server_info
        name = __method__
        desc 'Request server information from Jira'

        Rake::Task[name].clear if Rake::Task.task_defined?(name)
        namespace :jira do
          task name do
            puts Rujira::Api::ServerInfo.get.data.to_json
          end
        end
      end
    end
  end
end

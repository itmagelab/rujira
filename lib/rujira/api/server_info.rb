# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira server information via the REST API.
    # Allows retrieving details about the Jira server instance, including version and build info.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/serverInfo
    #
    class ServerInfo < Common
      # Retrieves Jira server information.
      #
      # @yield [builder] Optional block to configure additional request parameters.
      # @return [Object] The API response containing server details.
      #
      # @example Get Jira server information
      #   client.ServerInfo.get
      #
      def get(&block)
        builder do
          path 'serverInfo'
          instance_eval(&block) if block_given?
        end
        call
      end
    end
  end
end

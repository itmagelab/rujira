# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira server information via the REST API.
    # Retrieves details about the Jira server instance, including version and build info.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/serverInfo
    #
    class ServerInfo < Common
      # Retrieves Jira server information.
      #
      # @return [Object] The API response containing server details.
      #
      # @example Get server info
      #   client.Server_info.get
      #
      def get
        builder do
          path 'serverInfo'
        end
        call
      end
    end
  end
end

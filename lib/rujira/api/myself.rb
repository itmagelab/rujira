# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to the Jira "Myself" resource via the REST API.
    # Allows retrieving details about the currently authenticated user.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/myself
    #
    class Myself < Common
      # Retrieves details of the currently authenticated user.
      #
      # @return [Object] The API response containing user details.
      #
      # @example Get current user details
      #   client.Myself.get
      #
      def get
        builder do
          path 'myself'
        end
        run
      end
    end
  end
end

# frozen_string_literal: true

module Rujira
  module Resource
    # Represents the currently authenticated Jira user (Myself).
    # Provides access to basic user attributes retrieved from the Jira API.
    #
    class Myself < Common
      attr_reader :url, :email, :name, :id, :key

      # Initializes a Myself resource with data from the Jira API response.
      #
      # @param [Object] client The HTTP client used for API communication.
      # @param [Hash] args The user data hash returned by the Jira API.
      # @option args [String] 'self' The URL of the user's Jira profile.
      # @option args [String] 'key' The user's Jira key.
      # @option args [String] 'name' The user's display name.
      # @option args [String] 'emailAddress' The user's email address.
      def initialize(client, **args)
        super

        @url = args['self']

        @key = args['key']
        @name = args['name']
        @email = args['emailAddress']
      end
    end
  end
end

# frozen_string_literal: true

module Rujira
  module Resource
    # Represents a Jira project.
    # Provides access to project attributes and operations such as deletion.
    #
    class Project < Common
      attr_reader :url, :id, :key

      # Initializes a Project resource with data from the Jira API response.
      #
      # @param [Object] client The HTTP client used for API communication.
      # @param [Hash] args The project data hash returned by the Jira API.
      # @option args [String] 'self' The URL of the project in Jira.
      # @option args [String] 'id' The internal ID of the project.
      # @option args [String] 'key' The project key (e.g., PROJ).
      def initialize(client, **args)
        super

        @url = args['self']
        @id = args['id']
        @key = args['key']
      end

      # Deletes the project from Jira using the client's Project API.
      #
      # @return [Object] The API response from the delete operation.
      # @note This operation is irreversible and should be used with caution.
      def delete
        @client.Project.delete(@id)
      end
    end
  end
end

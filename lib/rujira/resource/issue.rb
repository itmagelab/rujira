# frozen_string_literal: true

module Rujira
  module Resource
    # Represents a Jira issue resource.
    # Provides access to issue attributes and actions such as adding comments.
    #
    # Example usage:
    #   issue = Rujira::Resource::Issue.new(client, data)
    #   issue.add_comment("This is a comment")
    #
    class Issue < Common
      # @return [String] The ID of the issue
      attr_reader :id
      # @return [String] The key of the issue (e.g., "TEST-123")
      attr_reader :key
      # @return [String] The URL to access this issue via Jira REST API
      attr_reader :url

      # Initializes an Issue resource
      #
      # @param [Object] client The API client instance used to make requests
      # @param [Hash] hash The issue data from the Jira API
      def initialize(client, **args)
        super

        @id = args['id']
        @key = args['key']
        @url = args['self']
      end

      # Adds a comment to this issue.
      #
      # @param [String] text The content of the comment
      # @return [Object] The API response after adding the comment
      #
      # @example Add a comment to an issue
      #   issue.add_comment("This is a new comment")
      def add_comment(text)
        @client.logger.debug "Adding comment to issue #{@key}"
        @client.Issue.add_comment(@id) do
          payload body: text
        end
      end

      def delete
        @client.logger.debug "Deleting issue #{@key}"
        @client.Issue.delete(@id)
      end
    end
  end
end

# frozen_string_literal: true

module Rujira
  module Resource
    # TODO
    class IssueType < Common
      # @return [String] The ID of the issue
      attr_reader :id
      # @return [String] The key of the issue (e.g., "TEST-123")
      attr_reader :name
      # @return [String] The URL to access this issue via Jira REST API
      attr_reader :url

      # Initializes an IssueType resource
      #
      # @param [Object] client The API client instance used to make requests
      # @param [Hash] hash The issue data from the Jira API
      def initialize(client, **args)
        super

        @id = args['id']
        @name = args['name']
        @url = args['self']
      end
    end
  end
end

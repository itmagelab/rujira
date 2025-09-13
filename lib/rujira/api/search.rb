# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira issue search via the REST API.
    # Allows searching for issues using JQL (Jira Query Language).
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/search
    #
    class Search < Common
      # Executes a search query against Jira issues.
      #
      # @yield [builder] Optional block to configure the request payload
      #   (e.g., provide JQL, fields, pagination).
      # @return [Object] The API response containing matching issues.
      #
      # @example Search issues with JQL
      #   client.Search.get do
      #     payload jql: "project = TEST AND status = 'To Do'", maxResults: 10
      #   end
      #
      def get(&block)
        builder do
          path 'search'
          method :post
          instance_eval(&block) if block_given?
        end
        run
      end
    end
  end
end

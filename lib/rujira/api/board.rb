# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira Agile board resources via the REST API.
    # API reference: https://docs.atlassian.com/jira-software/REST/9.17.0/#agile/1.0/board
    #
    class Board < Common
      # Initializes a new Board API client.
      #
      # @param [Object] client The HTTP client instance used to perform requests.
      #
      def initialize(client)
        super
        builder do
          rest_base 'rest/agile/1.0'
        end
      end

      # Retrieves details for a specific board by its ID.
      #
      # @param [Integer, String] id The board ID.
      # @return [Object] The API response containing board details.
      #
      def get(id)
        abort 'Board ID is required' if id.to_s.strip.empty?
        builder do
          path "board/#{id}"
        end
        run
      end

      # Lists all boards visible to the current user.
      #
      # @return [Object] The API response containing a list of boards.
      #
      def list
        builder do
          path 'board'
        end
        run
      end

      # Retrieves all sprints for a specific board.
      #
      # @param [Integer, String] id The board ID.
      # @return [Object] The API response containing sprints.
      #
      def sprint(id)
        abort 'Board ID is required' if id.to_s.strip.empty?
        builder do
          path "board/#{id}/sprint"
        end
        run
      end
    end
  end
end

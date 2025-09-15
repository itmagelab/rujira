# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira Agile board resources via the REST API.
    # Allows retrieving boards, board details, and sprints.
    #
    # API reference:
    # https://docs.atlassian.com/jira-software/REST/9.17.0/#agile/1.0/board
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
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing board details.
      #
      # @example Get board details
      #   client.Board.get(123)
      #
      def get(id, &block)
        abort 'Board ID is required' if id.to_s.strip.empty?
        builder do
          path "board/#{id}"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Lists all boards visible to the current user.
      #
      # Available query parameters:
      # - `startAt` [Integer]: The index of the first item to return (pagination).
      # - `maxResults` [Integer]: The maximum number of items to return.
      # - `type` [String]: Filters boards by type ("scrum" or "kanban").
      # - `name` [String]: Filters boards by name.
      # - `projectKeyOrId` [String]: Filters boards by associated project.
      #
      # @yield [builder] Optional block to configure query parameters.
      # @return [Object] The API response containing a list of boards.
      #
      # @example List boards with pagination
      #   client.Board.list do
      #     params startAt: 0, maxResults: 50
      #   end
      #
      def list(&block)
        builder do
          path 'board'
          instance_eval(&block) if block_given?
        end
        call
      end

      # Retrieves all sprints for a specific board.
      #
      # Available query parameters:
      # - `state` [String]: Filters sprints by state ("future", "active", "closed").
      # - `startAt` [Integer]: The index of the first item to return (pagination).
      # - `maxResults` [Integer]: The maximum number of items to return.
      #
      # @param [Integer, String] id The board ID.
      # @yield [builder] Optional block to configure query parameters.
      # @return [Object] The API response containing sprints.
      #
      # @example Get active sprints for a board
      #   client.Board.sprint(123) do
      #     params state: "active"
      #   end
      #
      def sprint(id, &block)
        abort 'Board ID is required' if id.to_s.strip.empty?
        builder do
          path "board/#{id}/sprint"
          instance_eval(&block) if block_given?
        end
        call
      end
    end
  end
end

# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira Agile board resources via the REST API.
    # Allows retrieving boards, board details, and sprints.
    #
    # API reference:
    # https://docs.atlassian.com/jira-software/REST/9.17.0/#agile/1.0/board
    #
    class Board < Common # rubocop:disable Metrics/ClassLength
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

      def create(&block)
        builder do
          method :post
          path 'board'
          instance_eval(&block) if block_given?
        end
        call
      end

      def delete(id, &block)
        abort 'Board ID is required' if id.to_s.strip.empty?
        builder do
          method :delete
          path "board/#{id}"
          instance_eval(&block) if block_given?
        end
        call
      end

      def backlog(id, &block)
        abort 'Board ID is required' if id.to_s.strip.empty?
        builder do
          path "board/#{id}/backlog"
          instance_eval(&block) if block_given?
        end
        call
      end

      def configuration(id, &block)
        abort 'Board ID is required' if id.to_s.strip.empty?
        builder do
          path "board/#{id}/configuration"
          instance_eval(&block) if block_given?
        end
        call
      end

      def issue(id, &block)
        abort 'Board ID is required' if id.to_s.strip.empty?
        builder do
          path "board/#{id}/issue"
          instance_eval(&block) if block_given?
        end
        call
      end

      def epic(id, &block)
        abort 'Board ID is required' if id.to_s.strip.empty?
        builder do
          path "board/#{id}/epic"
          instance_eval(&block) if block_given?
        end
        call
      end

      def epic_issues(id, epic_id, &block)
        abort 'Board ID is required' if id.to_s.strip.empty?
        builder do
          path "board/#{id}/epic/#{epic_id}/issue"
          instance_eval(&block) if block_given?
        end
        call
      end

      def epic_none_issues(id, &block)
        abort 'Board ID is required' if id.to_s.strip.empty?
        builder do
          path "board/#{id}/epic/none/issue"
          instance_eval(&block) if block_given?
        end
        call
      end

      def project(id, &block)
        abort 'Board ID is required' if id.to_s.strip.empty?
        builder do
          path "board/#{id}/project"
          instance_eval(&block) if block_given?
        end
        call
      end

      def settings(id, &block)
        abort 'Board ID is required' if id.to_s.strip.empty?
        builder do
          path "board/#{id}/settings/refined-velocity"
          instance_eval(&block) if block_given?
        end
        call
      end

      def set_settings(id, &block)
        abort 'Board ID is required' if id.to_s.strip.empty?
        builder do
          method :put
          path "board/#{id}/settings/refined-velocity"
          instance_eval(&block) if block_given?
        end
        call
      end

      def properties(id, &block)
        abort 'Board ID is required' if id.to_s.strip.empty?
        builder do
          path "board/#{id}/properties"
          instance_eval(&block) if block_given?
        end
        call
      end

      def set_properties(id, property_key, &block)
        abort 'board id is required' if id.to_s.strip.empty?
        builder do
          method :put
          path "board/#{id}/properties/#{property_key}"
          instance_eval(&block) if block_given?
        end
        call
      end

      def get_properties(id, property_key, &block)
        abort 'board id is required' if id.to_s.strip.empty?
        builder do
          path "board/#{id}/properties/#{property_key}"
          instance_eval(&block) if block_given?
        end
        call
      end

      def delete_properties(id, property_key, &block)
        abort 'board id is required' if id.to_s.strip.empty?
        builder do
          method :delete
          path "board/#{id}/properties/#{property_key}"
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

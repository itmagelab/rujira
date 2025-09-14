# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira sprints via the Agile REST API.
    # Allows creating, updating, retrieving, and managing sprints and their issues.
    #
    # API reference:
    # https://docs.atlassian.com/jira-software/REST/9.17.0/#agile/1.0/sprint
    #
    class Sprint < Common
      # Initializes a new Sprint API client.
      #
      # @param [Object] client The HTTP client instance used to perform requests.
      #
      def initialize(client)
        super
        builder do
          rest_base 'rest/agile/1.0'
        end
      end

      # Creates a new sprint.
      #
      # @yield [builder] Optional block to configure the sprint payload.
      # @return [Object] The API response containing the created sprint.
      #
      # @example Create a sprint
      #   client.Sprint.create do
      #     payload name: "Sprint 1", startDate: "2025-09-01", endDate: "2025-09-14", originBoardId: 1
      #   end
      #
      def create(&block)
        builder do
          path 'sprint'
          headers 'Content-Type': 'application/json', Accept: 'application/json'
          method :post
          instance_eval(&block) if block_given?
        end
        call
      end

      # Updates an existing sprint partially.
      #
      # @param [Integer] id The sprint ID.
      # @yield [builder] Block to configure update payload (required).
      # @return [Object] The API response after updating the sprint.
      #
      # @example Update sprint
      #   client.Sprint.update(1) do
      #     payload name: "Updated Sprint Name"
      #   end
      #
      def update(id, &block)
        abort 'Sprint ID is required' if id.to_s.strip.empty?
        raise ArgumentError, 'block is required' unless block

        builder do
          path "sprint/#{id}"
          headers 'Content-Type': 'application/json', Accept: 'application/json'
          method :post
          instance_eval(&block)
        end
        call
      end

      # Replaces an existing sprint.
      #
      # @param [Integer] id The sprint ID.
      # @yield [builder] Block to configure replace payload (required).
      # @return [Object] The API response after replacing the sprint.
      #
      # @example Replace sprint
      #   client.Sprint.replace(1) do
      #     payload name: "New Sprint Name", startDate: "2025-09-01", endDate: "2025-09-14"
      #   end
      #
      def replace(id, &block)
        abort 'Sprint ID is required' if id.to_s.strip.empty?
        raise ArgumentError, 'block is required' unless block

        builder do
          path "sprint/#{id}"
          headers 'Content-Type': 'application/json', Accept: 'application/json'
          method :put
          instance_eval(&block)
        end
        call
      end

      # Retrieves details of a specific sprint.
      #
      # @param [Integer] id The sprint ID.
      # @return [Object] The API response containing sprint details.
      #
      def get(id)
        abort 'Sprint ID is required' if id.to_s.strip.empty?
        builder do
          path "sprint/#{id}"
        end
        call
      end

      # Retrieves all issues in a sprint.
      #
      # @param [Integer] id The sprint ID.
      # @return [Object] The API response containing issues.
      #
      def get_issue(id)
        abort 'Sprint ID is required' if id.to_s.strip.empty?
        builder do
          path "sprint/#{id}/issue"
        end
        call
      end

      # Deletes a sprint.
      #
      # @param [Integer] id The sprint ID.
      # @return [Object] The API response after deletion.
      #
      def delete(id)
        abort 'Sprint ID is required' if id.to_s.strip.empty?
        builder do
          method :delete
          path "sprint/#{id}"
        end
        call
      end

      # Retrieves all properties of a sprint.
      #
      # @param [Integer] id The sprint ID.
      # @return [Object] The API response containing sprint properties.
      #
      def properties(id)
        abort 'Sprint ID is required' if id.to_s.strip.empty?
        builder do
          path "sprint/#{id}/properties"
        end
        call
      end

      # Adds issues to a sprint.
      #
      # @param [Integer] id The sprint ID.
      # @param [Array<Integer>] issues List of issue IDs to add to the sprint.
      # @return [Object] The API response after adding issues.
      #
      # @example Add issues to a sprint
      #   client.Sprint.issue(1, [101, 102])
      #
      def issue(id, issues)
        abort 'Sprint ID is required' if id.to_s.strip.empty?
        builder do
          method :post
          path "sprint/#{id}/issue"
          payload issues: issues
        end
        call
      end
    end
  end
end

# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira dashboards via the REST API.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/dashboard
    #
    class Dashboard < Common
      # Retrieves a specific dashboard by its ID.
      #
      # @param [Integer, String] id The dashboard ID.
      # @return [Object] The API response containing dashboard details.
      #
      # @example Get a dashboard by ID
      #   client.Dashboard.get(10001)
      #
      def get(id, &block)
        abort 'Dashboard ID is required' if id.to_s.strip.empty?
        builder do
          path "dashboard/#{id}"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Lists all dashboards visible to the current user.
      #
      # Optional query parameters:
      # - `startAt` [Integer] The index of the first dashboard to return (default: 0).
      # - `maxResults` [Integer] The maximum number of dashboards to return (default: 20, max: 1000).
      # - `filter` [String] A string to filter dashboards by name.
      #
      # @yield [builder] Optional block to configure query parameters.
      # @return [Object] The API response containing a list of dashboards.
      #
      # @example List dashboards
      #   client.Dashboard.list
      #
      # @example List dashboards with pagination
      #   client.Dashboard.list do
      #     params startAt: 20, maxResults: 50
      #   end
      #
      def list(&block)
        builder do
          path 'dashboard'
          instance_eval(&block) if block_given?
        end
        call
      end
    end
  end
end

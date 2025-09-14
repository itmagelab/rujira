# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira dashboards via the REST API.
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/myself
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
      def get(id)
        abort 'Dashboard ID is required' if id.to_s.strip.empty?
        builder do
          path "dashboard/#{id}"
        end
        call
      end

      # Lists all dashboards visible to the current user.
      #
      # @return [Object] The API response containing a list of dashboards.
      #
      # @example List dashboards
      #   client.Dashboard.list
      #
      def list
        builder do
          path 'dashboard'
        end
        call
      end
    end
  end
end

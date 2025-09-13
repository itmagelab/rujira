# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira permissions via the REST API.
    # Allows listing all permission schemes available in Jira.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/permissions
    #
    class Permissions < Common
      # Retrieves the list of all permissions in Jira.
      #
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing permissions details.
      #
      # @example List all permissions
      #   client.Permissions.list
      #
      def list
        builder do
          path 'permissions'
          method :get
        end
        run
      end

      # Retrieves the list of my permissions in Jira.
      #
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing permissions details.
      #
      # @example List all permissions
      #   client.Permissions.my
      #
      def my
        builder do
          path 'mypermissions'
          method :get
        end
        run
      end
    end
  end
end

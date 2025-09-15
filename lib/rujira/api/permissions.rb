# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira permissions via the REST API.
    # Allows listing all permission schemes and the current user's permissions.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/permissions
    #
    class Permissions < Common
      # Retrieves the list of all permission schemes in Jira.
      #
      # @yield [builder] Optional block to configure additional request parameters.
      # @return [Object] The API response containing permissions details.
      # @example List all permissions
      #   client.Permissions.list
      def list(&block)
        builder do
          path 'permissions'
          method :get
          instance_eval(&block) if block_given?
        end
        call
      end

      # Retrieves the current user's permissions in Jira.
      #
      # @yield [builder] Optional block to configure additional request parameters.
      # @return [Object] The API response containing the current user's permissions.
      # @example List current user's permissions
      #   client.Permissions.my
      def my(&block)
        builder do
          path 'mypermissions'
          method :get
          instance_eval(&block) if block_given?
        end
        call
      end
    end
  end
end

# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira application roles via the REST API.
    # Allows listing, retrieving, and updating application roles.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/applicationrole
    #
    class ApplicationRole < Common
      # Updates multiple application roles in bulk.
      #
      # @yield [builder] Block to configure the payload for bulk update.
      # @return [Object] The API response after updating roles.
      #
      # @example Bulk update roles
      #   client.Application_role.put_bulk do
      #     payload [
      #       { key: "jira-software-users", groups: ["jira-users"] },
      #       { key: "jira-administrators", groups: ["admins"] }
      #     ]
      #   end
      #
      def put_bulk(&block)
        builder do
          method :put
          path 'applicationrole'
          instance_eval(&block) if block_given?
        end
        call
      end

      # Lists all application roles.
      #
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing all application roles.
      #
      # @example List all application roles
      #   client.Application_role.list
      #
      def list(&block)
        builder do
          path 'applicationrole'
          instance_eval(&block) if block_given?
        end
        call
      end

      # Retrieves a specific application role by key.
      #
      # @param [String] key The key of the application role.
      # @return [Object] The API response containing role details.
      #
      # @example Get a role
      #   client.Application_role.get("jira-software-users")
      #
      def get(key, &block)
        builder do
          path "applicationrole/#{key}"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Updates a specific application role by key.
      #
      # @param [String] key The key of the application role to update.
      # @yield [builder] Block to configure the payload for update.
      # @return [Object] The API response after updating the role.
      #
      # @example Update a role
      #   client.Application_role.put("jira-software-users") do
      #     payload groups: ["jira-users", "new-group"]
      #   end
      #
      def put(key, &block)
        builder do
          method :put
          path "applicationrole/#{key}"
          instance_eval(&block) if block_given?
        end
        call
      end
    end
  end
end

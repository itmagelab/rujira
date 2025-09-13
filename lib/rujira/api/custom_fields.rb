# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira custom fields via the REST API.
    # Allows retrieving and deleting custom fields.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/customFields
    #
    class CustomFields < Common
      # Retrieves all custom fields.
      #
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing all custom fields.
      #
      # @example Get all custom fields
      #   client.CustomFields.get
      #
      def get
        builder do
          path 'customFields'
        end
        run
      end

      # Deletes custom fields based on provided parameters.
      #
      # @yield [builder] Block to configure the deletion payload or parameters.
      # @return [Object] The API response after deletion.
      #
      # @example Delete custom fields
      #   client.CustomFields.delete do
      #     payload fieldIds: ["customfield_10001", "customfield_10002"]
      #   end
      #
      def delete(&block)
        builder do
          method :delete
          path 'customFields'
          instance_eval(&block) if block_given?
        end
        run
      end
    end
  end
end

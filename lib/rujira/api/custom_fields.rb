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
      # Retrieves all custom fields in Jira.
      #
      # The response typically contains:
      # - `id` (e.g., "customfield_10001")
      # - `name` (field display name)
      # - `schema` (field type and configuration)
      #
      # @yield [builder] Optional block to configure the request (e.g., add query parameters).
      # @return [Object] The API response containing an array of custom fields.
      #
      # @example Get all custom fields
      #   client.CustomFields.get
      #
      # @example With query parameters
      #   client.CustomFields.get do
      #     params maxResults: 50, startAt: 0
      #   end
      #
      def get(&block)
        builder do
          path 'customFields'
          instance_eval(&block) if block_given?
        end
        call
      end

      # Deletes one or more custom fields by their IDs.
      #
      # The request must include `fieldIds` in the payload.
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
        call
      end
    end
  end
end

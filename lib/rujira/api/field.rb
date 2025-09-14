# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira fields via the REST API.
    # Allows listing all fields and creating new fields.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/field
    #
    class Field < Common
      # Retrieves all fields.
      #
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing all fields.
      #
      # @example List all fields
      #   client.Field.get
      #   client.Field.list
      #
      def list
        builder do
          path 'field'
        end
        call
      end
      alias get list

      # Creates a new field.
      #
      # @yield [builder] Block to configure the payload for the new field.
      # @return [Object] The API response after creating the field.
      #
      # @example Create a custom field
      #   client.Field.create do
      #     payload name: "My Field", type: "com.atlassian.jira.plugin.system.customfieldtypes:textfield"
      #   end
      #
      def create(&block)
        builder do
          method :post
          path 'field'
          instance_eval(&block) if block_given?
        end
        call
      end
    end
  end
end

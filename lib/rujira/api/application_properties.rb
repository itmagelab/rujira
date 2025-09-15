# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira application properties via the REST API.
    # Allows listing, retrieving, updating, and accessing advanced settings.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/application-properties
    #
    class ApplicationProperties < Common
      # Retrieves all application properties.
      #
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing all properties.
      #
      # @example List all application properties
      #   client.application_properties.list
      #
      def list(&block)
        builder do
          path 'application-properties'
          instance_eval(&block) if block_given?
        end
        call
      end

      alias get list

      # Updates a specific application property.
      #
      # @param [String] id The property ID to update.
      # @yield [builder] Block to configure the payload.
      # @return [Object] The API response after updating the property.
      #
      # @example Update an application property
      #   client.application_properties.set("jira.option.someFeature") do
      #     payload value: true
      #   end
      #
      def set(id, &block)
        builder do
          method :put
          path "application-properties/#{id}"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Retrieves advanced application settings.
      #
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing advanced settings.
      #
      # @example Get advanced settings
      #   client.application_properties.advanced_settings
      #
      def advanced_settings(&block)
        builder do
          path 'application-properties/advanced-settings'
          instance_eval(&block) if block_given?
        end
        call
      end
    end
  end
end

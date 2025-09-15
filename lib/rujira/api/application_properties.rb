# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira application properties via the REST API.
    # You can list all properties, filter them with query parameters,
    # update specific properties, and access advanced settings.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/application-properties
    #
    class ApplicationProperties < Common
      # Retrieves application properties.
      #
      # @param [Hash] params Optional query parameters:
      #   - :key [String] Return property with a specific key.
      #   - :permissionLevel [String] Restrict results by permission level (SYSADMIN, ADMIN, USER).
      #   - :keyFilter [String] Return properties matching a wildcard filter (e.g. "jira.option*").
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing properties.
      #
      # @example List all application properties
      #   client.ApplicationProperties.list
      #
      # @example Filter by key
      #   client.ApplicationProperties.list do
      #     params key: "jira.lf.date.format"
      #   end
      #
      # @example Filter by permission level
      #   client.ApplicationProperties.list do
      #     params permissionLevel: "SYSADMIN"
      #   end
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
      #   client.ApplicationProperties.set("jira.option.allowattachments") do
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
      #   client.ApplicationProperties.advanced_settings
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

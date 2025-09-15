# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira configuration settings via the REST API.
    # The configuration resource contains system-wide settings such as
    # the base URL, time tracking configuration, attachment settings, etc.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/configuration
    #
    class Configuration < Common
      # Retrieves the current Jira configuration.
      #
      # The response typically includes:
      # - `timeTrackingConfiguration` (time tracking settings)
      # - `attachmentsEnabled` (whether attachments are enabled)
      # - `baseUrl` (the base URL of Jira)
      #
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing configuration details.
      #
      # @example Get Jira configuration
      #   client.Configuration.get
      #
      # @example With a block (adding custom headers)
      #   client.Configuration.get do
      #     headers "X-Experimental-API" => "true"
      #   end
      #
      def get(&block)
        builder do
          path 'configuration'
          instance_eval(&block) if block_given?
        end
        call
      end
    end
  end
end

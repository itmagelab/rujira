# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira configuration settings via the REST API.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/configuration
    #
    class Configuration < Common
      # Retrieves the current Jira configuration.
      #
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing configuration details.
      #
      # @example Get Jira configuration
      #   client.Configuration.get
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

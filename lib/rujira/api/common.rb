# frozen_string_literal: true

module Rujira
  module Api
    # Base class for Jira API resources.
    # Provides common request setup, authorization, and request execution.
    #
    class Common
      # Initializes a new API resource.
      #
      # @param [Object] client The HTTP client instance used to build and dispatch requests.
      #
      def initialize(client)
        # Store the passed client object in an instance variable for later use
        @client = client

        # Configure requests using the client's builder DSL
        @client.request.builder do
          # Set the Bearer token for authorization
          bearer @token

          # Specify the default HTTP method for requests
          method :get

          # Set the base path for Jira REST API
          rest_base 'rest/api/2'
        end
      end

      # Sets up the request builder for @request.
      # Automatically applies the bearer token from Configuration.token.
      # If a block is given, it is evaluated in the context of the builder,
      # allowing additional customization of the request (e.g., headers, params).
      #
      # @yield [builder] Optional block to configure the request builder.
      # @return [Object] The configured request builder stored in @request.
      def builder(&block) = @client.request.builder(&block)

      # Executes the configured request.
      #
      # @return [Object] The API response after dispatching the request.
      def run = @client.dispatch
    end
  end
end

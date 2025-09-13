# frozen_string_literal: true

module Rujira
  module Api
    # TODO: add docs
    # Some description
    class Common
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

      # Delegate execution to the client's dispatch method
      # This triggers the configured request to be sent
      def run = @client.dispatch
    end
  end
end

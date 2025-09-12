# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    class Common
      def initialize(client)
        @client = client
        @client.request.builder do
          bearer Configuration.token
          method :get
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

      def run = @client.dispatch
    end
  end
end

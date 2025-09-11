# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    class Common
      def initialize
        @request = Request.new
      end

      # Sets up the request builder for @request.
      # Automatically applies the bearer token from Configuration.token.
      # If a block is given, it is evaluated in the context of the builder,
      # allowing additional customization of the request (e.g., headers, params).
      #
      # @yield [builder] Optional block to configure the request builder.
      # @return [Object] The configured request builder stored in @request.
      def builder(&block)
        @request = @request.builder do
          bearer Configuration.token
          instance_eval(&block) if block_given?
        end
      end

      def run
        @request.run
      end

      def self.method_missing(method, *_args)
        method = [method.to_sym]
        raise "The method #{method} does not exist.
               The following methods are available: #{methods(false)}"
      end

      def self.respond_to_missing?(method, include_private = false)
        methods.include?(method) || super
      end
    end
  end
end

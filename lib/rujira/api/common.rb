# frozen_string_literal: true

module Rujira
  module Api
    # Base class for Jira API resources.
    # Provides common request setup, authorization, and request execution.
    #
    # Every call builds its own request object, so parameters, headers and
    # payloads never leak from one call to another.
    #
    class Common
      # Default base path of the Jira REST API.
      DEFAULT_REST_BASE = 'rest/api/2'

      # Initializes a new API resource.
      #
      # @param [Object] client The HTTP client instance used to build and dispatch requests.
      #
      def initialize(client)
        # Store the passed client object in an instance variable for later use
        @client = client
        @metadata = {}
      end

      # Base REST path used by the resource.
      #
      # @return [String] The base path, e.g. 'rest/api/2'
      #
      def rest_base
        DEFAULT_REST_BASE
      end

      # Builds a request, executes it and returns the response.
      #
      # @param [String] path Path relative to the REST base path.
      # @param [Symbol] method HTTP method.
      # @param [Object, nil] payload Request body.
      # @param [Hash, nil] headers Request headers.
      # @param [Hash, nil] params Query parameters.
      # @yield [Request] Optional block to fine tune the request.
      # @return [Object] The API response.
      #
      # @example
      #   request(path: 'issue/TEST-123', method: :put, payload: { fields: { summary: 'New' } })
      #
      def request(path:, method: :get, payload: nil, headers: nil, params: nil, &block)
        @request = build_request(
          path: path, method: method, payload: payload, headers: headers, params: params, &block
        )
        call
      end

      # Builds a request without executing it.
      #
      # @param [String] path Path relative to the REST base path.
      # @param [Symbol] method HTTP method.
      # @param [Object, nil] payload Request body.
      # @param [Hash, nil] headers Request headers.
      # @param [Hash, nil] params Query parameters.
      # @yield [Request] Optional block to fine tune the request.
      # @return [Request] The prepared request.
      #
      def build_request(path:, method: :get, payload: nil, headers: nil, params: nil, &block)
        req = Request.new
        req.rest_base rest_base
        req.method method
        req.path path
        req.payload payload unless payload.nil?
        req.headers headers unless headers.nil?
        req.params params unless params.nil?
        req.builder(&block) if block
        req
      end

      # Sets up the request builder.
      # Every call starts from a clean request, so the block never inherits
      # headers, params or payload of a previous call.
      #
      # @yield [builder] Optional block to configure the request builder.
      # @return [Request] The configured request stored in @request.
      def builder(&block)
        @request = Request.new
        @request.rest_base rest_base
        @request.builder(&block)
      end

      # Executes the configured request.
      #
      # @return [Object] The API response after dispatching the request.
      def call
        @client.logger.debug "Call the method: #{caller_locations(1, 1)[0].label}"
        return @client.dispatch(@request) unless @client.wrap_responses
        return self if @client.lazy

        to_obj
      end

      # Executes the configured request via the client's dispatch mechanism.
      #
      # @return [Object] The raw API response from the dispatched request.
      def commit
        @client.dispatch(@request)
      end
      alias execute commit

      # Converts the API response into structured Ruby objects.
      # If the response is an array of hashes, maps each element through `process`.
      # If it's a single hash, processes it directly. Otherwise, returns as-is.
      #
      # @return [Object] Processed response as one or more resource objects, or original response.
      def to_obj
        response = execute

        return response.map { |el| process(el) } if response.is_a?(Array) && response.all?(Hash)
        return response unless response.is_a?(Hash)

        process response
      end

      # Processes a single response hash by merging metadata and instantiating
      # the corresponding Resource object based on the current class name.
      #
      # When the API has no dedicated Resource class the generic
      # Rujira::Resource::Common is used instead of raising.
      #
      # @param [Hash] response The API response hash to process.
      # @return [Object] An instance of the corresponding Resource class.
      def process(response)
        response.merge!(@metadata)
        resource_class_for(self.class).new(@client, **response)
      end

      # Sets ownership context for the resource by storing a parent ID or key
      # in metadata, which may be used during object instantiation.
      #
      # @param [String, Integer] id_or_key The ID or key of the parent resource.
      # @return [Hash] The updated metadata hash with the parent set.
      def owned_by(id_or_key)
        @metadata.merge!({ parent: id_or_key })
      end

      # Reads a field from an API response.
      #
      # Works both with raw hashes (string or symbol keys) and with resource
      # objects, so the same code can be used in both response modes.
      #
      # @param [Object] item Response item.
      # @param [String] key Name of the field.
      # @return [Object, nil] The value of the field.
      def field(item, key)
        return item.public_send(key) if item.respond_to?(key)

        item[key] || item[key.to_sym]
      end

      private

      # Looks up the Resource class matching an API class.
      #
      # @param [Class] api_class The API class.
      # @return [Class] The Resource class or the generic Resource::Common.
      #
      def resource_class_for(api_class)
        name = api_class.name.to_s.sub('Api', 'Resource')
        return Object.const_get(name) if Object.const_defined?(name)

        Resource::Common
      end

      # Ensures that a required argument was provided.
      #
      # @param [Object] value The value to check.
      # @param [String] message Message of the raised error.
      # @return [Object] The value itself.
      # @raise [Rujira::ValidationError] When the value is blank.
      #
      def required!(value, message)
        raise Rujira::ValidationError, message if value.nil? || value.to_s.strip.empty?

        value
      end

      # Reports a missing argument.
      #
      # The API classes validate their arguments with `abort`. Overriding it
      # here turns every one of those checks into a regular, rescuable
      # Rujira::ValidationError instead of a SystemExit that would terminate
      # the host process.
      #
      # @param [String] message Message of the raised error.
      # @raise [Rujira::ValidationError] Always.
      #
      def abort(message = nil)
        raise Rujira::ValidationError, message.to_s
      end
    end
  end
end

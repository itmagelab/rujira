# frozen_string_literal: true

module Rujira
  module Resource
    # Base class for Jira resources.
    # Keeps the raw response and provides helpers to work with it.
    #
    class Common # rubocop:disable Style/Documentation
      attr_reader :response

      def initialize(client, **response)
        @client = client
        @response = response
      end

      # Reloads the resource from Jira.
      #
      # Resources that support reloading override this method.
      #
      # @raise [NotImplementedError] When the resource cannot be reloaded.
      #
      def reload!
        raise NotImplementedError, "#{self.class} does not support reload!"
      end

      protected

      # Updates the resource with a fresh API response.
      #
      # @param [Object] data Resource object or raw response hash.
      # @return [self] The updated resource.
      #
      def update_from(data)
        payload = data.respond_to?(:response) ? data.response : data
        initialize(@client, **payload)
        self
      end
    end
  end
end

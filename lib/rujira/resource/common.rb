# frozen_string_literal: true

module Rujira
  module Resource
    class Common # rubocop:disable Style/Documentation
      attr_reader :response

      def initialize(client, **response)
        @client = client
        @response = response
      end

      def reload!
        user = @client.User.get(@key)
        initialize(@client, **user.response)
      end
    end
  end
end

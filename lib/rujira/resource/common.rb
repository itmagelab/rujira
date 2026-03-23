# frozen_string_literal: true

module Rujira
  module Resource
    class Common # rubocop:disable Style/Documentation
      def initialize(client, **_args)
        @client = client
      end
    end
  end
end

# frozen_string_literal: true

module Rujira
  module Resource
    class Myself < Common
      attr_reader :url, :email, :name, :id, :key

      def initialize(client, **args)
        super

        @url = args['self']

        @key = args['key']
        @name = args['name']
        @email = args['emailAddress']
      end
    end
  end
end

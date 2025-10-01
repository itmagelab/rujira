# frozen_string_literal: true

module Rujira
  module Resource
    class Project < Common
      def initialize(client, **args)
        super

        @url = args['self']
        @id = args['id']
        @key = args['key']
      end

      def delete
        @client.Project.delete(@id)
      end
    end
  end
end

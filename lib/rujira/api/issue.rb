# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    class Issue
      def self.get(id)
        Entity.build do
          path "rest/api/2/issue/#{id}"
        end.get.body
      end

      def self.create(**data)
        Entity.build do
          path 'rest/api/2/issue'
          data data
        end.post.body
      end
    end
  end
end

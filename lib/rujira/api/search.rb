# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    class Search
      def self.get(**data)
        Entity.build do
          path 'rest/api/2/search'
          data data
        end.post.body
      end
    end
  end
end

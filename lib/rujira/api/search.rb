# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    class Search < Item
      def self.get(**data)
        entity = Entity.build do
          path 'rest/api/2/search'
          data data
          method :POST
        end
        new(entity.commit)
      end
    end
  end
end

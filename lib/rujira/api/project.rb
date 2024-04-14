# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    class Project < Item
      def self.get(id)
        entity = Entity.build do
          path "rest/api/2/project/#{id}"
        end
        new(entity.commit)
      end
    end
  end
end

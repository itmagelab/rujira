# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    class Project
      def self.get(id)
        Entity.build do
          path "rest/api/2/project/#{id}"
        end.get.body
      end
    end
  end
end

# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/8.17.1/#api/2/myself
    class Myself < Item
      def self.get
        entity = Entity.build do
          path 'myself'
        end
        new(entity.commit)
      end

      def name
        @data['name']
      end
    end
  end
end

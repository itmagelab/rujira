# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/8.17.1/#api/2/search
    class Search < Item
      def self.get(**data)
        entity = Entity.build do
          path 'search'
          data data
          method :POST
        end
        entity.commit['issues'].map do |issue|
          Issue.new(issue)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/search
    class Search < Item
      def self.get(&block)
        entity = Entity.build do
          path 'search'
          method :POST
          instance_eval(&block) if block_given?
        end
        new(entity.commit)
      end

      def iter
        data['issues'].map do |issue|
          Issue.new(issue)
        end
      end
    end
  end
end

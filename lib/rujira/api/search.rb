# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/search
    class Search < Common
      def self.get(&block)
        rq = self.rq.builder do
          path 'search'
          method :post
          instance_eval(&block) if block_given?
        end
        new(rq.run)
      end

      def iter
        data['issues'].map do |issue|
          Issue.new(issue)
        end
      end
    end
  end
end

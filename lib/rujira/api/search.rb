# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/search
    class Search < Common
      def get(&block)
        builder do
          path 'search'
          method :post
          instance_eval(&block) if block_given?
        end
        run
      end
    end
  end
end

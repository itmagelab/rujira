# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/myself
    class Myself < Common
      def self.get
        rq = self.rq.builder do
          path 'myself'
        end
        new(rq.run)
      end

      def name
        @data['name']
      end
    end
  end
end

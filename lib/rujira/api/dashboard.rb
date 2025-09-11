# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/myself
    class Dashboard < Common
      def self.get(id)
        new.builder do
          path "dashboard/#{id}"
        end.run
      end

      def self.list
        new.builder do
          path 'dashboard'
        end.run
      end
    end
  end
end

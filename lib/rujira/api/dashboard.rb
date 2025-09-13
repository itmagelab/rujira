# frozen_string_literal: true

module Rujira
  module Api
    # TODO: add docs
    # Some description
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/myself
    class Dashboard < Common
      def get(id)
        abort 'Dashboard ID is required' if id.to_s.strip.empty?
        builder do
          path "dashboard/#{id}"
        end
        run
      end

      def list
        builder do
          path 'dashboard'
        end
        run
      end
    end
  end
end

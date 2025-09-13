# frozen_string_literal: true

module Rujira
  module Api
    # TODO: add docs
    # Some description
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/myself
    class Myself < Common
      def get
        builder do
          path 'myself'
        end
        run
      end
    end
  end
end

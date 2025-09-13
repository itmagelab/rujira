# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/serverInfo
    class ServerInfo < Common
      def get
        builder do
          path 'serverInfo'
        end
        run
      end
    end
  end
end

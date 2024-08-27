# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/serverInfo
    class ServerInfo < Item
      def self.get
        entity = Entity.build do
          path 'serverInfo'
        end
        new(entity.commit)
      end
    end
  end
end

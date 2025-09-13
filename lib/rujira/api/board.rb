# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/jira-software/REST/9.17.0/#agile/1.0/board
    class Board < Common
      def initialize(client)
        super
        builder do
          rest_base 'rest/agile/1.0'
        end
      end

      def get(id)
        builder do
          path "board/#{id}"
        end
        run
      end

      def list
        builder do
          path 'board'
        end
        run
      end

      def sprint(id)
        builder do
          path "board/#{id}/sprint"
        end
        run
      end
    end
  end
end

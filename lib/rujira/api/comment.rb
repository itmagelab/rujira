# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/comment/%7BcommentId%7D/properties
    class Comment < Common
      def create(id_or_key, &block)
        builder do
          path "issue/#{id_or_key}/comment"
          method :post
          instance_eval(&block) if block_given?
        end
        run
      end
    end
  end
end

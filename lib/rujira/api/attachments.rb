# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/issue/%7BissueIdOrKey%7D/attachments
    class Attachments < Common
      def create(id_or_key, path, &block)
        abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
        client = @client
        builder do
          path "issue/#{id_or_key}/attachments"
          method :post
          headers 'X-Atlassian-Token': 'no-check'
          payload file: client.file(path)
          instance_eval(&block) if block_given?
        end
        run
      end
    end
  end
end

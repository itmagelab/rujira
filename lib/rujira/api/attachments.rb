# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/issue/%7BissueIdOrKey%7D/attachments
    class Attachments < Common
      def self.create(id_or_key, path, &block)
        new.builder do
          path "issue/#{id_or_key}/attachments"
          method :post
          headers 'Content-Type': 'multipart/form-data', 'X-Atlassian-Token': 'nocheck',
                  'Transfer-Encoding': 'chunked', 'Content-Length': File.size(path).to_s
          data file: Faraday::Multipart::FilePart.new(path, 'multipart/form-data')
          instance_eval(&block) if block_given?
        end.run
      end
    end
  end
end

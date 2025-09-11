# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/issue
    class Issue < Common
      def self.create(&block)
        rq = self.rq.builder do
          path 'issue'
          method :post
          instance_eval(&block) if block_given?
        end
        new(rq.run)
      end

      def self.get(id_or_key, &block)
        rq = self.rq.builder do
          path "issue/#{id_or_key}"
          instance_eval(&block) if block_given?
        end
        new(rq.run)
      end

      def self.del(id_or_key, &block)
        rq = self.rq.builder do
          path "issue/#{id_or_key}"
          method :delete
          instance_eval(&block) if block_given?
        end
        rq.run
      end

      def self.edit(id_or_key, &block)
        rq = self.rq.builder do
          path "issue/#{id_or_key}"
          method :put
          instance_eval(&block) if block_given?
        end
        new(rq.run)
      end

      def self.comment(id_or_key, &block)
        rq = self.rq.builder do
          path "issue/#{id_or_key}/comment"
          method :post
          instance_eval(&block) if block_given?
        end
        Comment.new(rq.run)
      end

      def self.watchers(id_or_key, name, &block)
        rq = self.rq.builder do
          path "issue/#{id_or_key}/watchers"
          method :post
          data name.to_json
          instance_eval(&block) if block_given?
        end
        new(rq.run)
      end

      def self.attachments(id_or_key, path, &block)
        rq = self.rq.builder do
          path "issue/#{id_or_key}/attachments"
          method :post
          headers 'Content-Type': 'multipart/form-data', 'X-Atlassian-Token': 'nocheck',
                  'Transfer-Encoding': 'chunked', 'Content-Length': File.size(path).to_s
          data file: Faraday::Multipart::FilePart.new(path, 'multipart/form-data')
          instance_eval(&block) if block_given?
        end
        Attachments.new(rq.run)
      end
    end
  end
end

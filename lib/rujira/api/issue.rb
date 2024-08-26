# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/issue
    class Issue < Item
      def self.create(&block)
        entity = Entity.build do
          path 'issue'
          method :POST
          instance_eval(&block) if block_given?
        end
        new(entity.commit)
      end

      def self.get(id_or_key, &block)
        entity = Entity.build do
          path "issue/#{id_or_key}"
          instance_eval(&block) if block_given?
        end
        new(entity.commit)
      end

      def self.del(id_or_key, &block)
        entity = Entity.build do
          path "issue/#{id_or_key}"
          method :DELETE
          instance_eval(&block) if block_given?
        end
        entity.commit
      end

      def self.edit(id_or_key, &block)
        entity = Entity.build do
          path "issue/#{id_or_key}"
          method :PUT
          instance_eval(&block) if block_given?
        end
        new(entity.commit)
      end

      def self.comment(id_or_key, &block)
        entity = Entity.build do
          path "issue/#{id_or_key}/comment"
          method :POST
          instance_eval(&block) if block_given?
        end
        Comment.new(entity.commit)
      end

      def self.watchers(id_or_key, name, &block)
        entity = Entity.build do
          path "issue/#{id_or_key}/watchers"
          method :POST
          data name.to_json
          instance_eval(&block) if block_given?
        end
        new(entity.commit)
      end

      def self.attachments(id_or_key, path, &block)
        entity = Entity.build do
          path "issue/#{id_or_key}/attachments"
          method :POST
          headers 'Content-Type': 'multipart/form-data', 'X-Atlassian-Token': 'nocheck',
                  'Transfer-Encoding': 'chunked', 'Content-Length': File.size(path).to_s
          data file: Faraday::Multipart::FilePart.new(path, 'multipart/form-data')
          instance_eval(&block) if block_given?
        end
        Attachments.new(entity.commit)
      end
    end
  end
end

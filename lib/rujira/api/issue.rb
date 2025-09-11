# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/issue
    class Issue < Common
      def self.create(&block)
        new.builder do
          path 'issue'
          method :post
          instance_eval(&block) if block_given?
        end.run
      end

      def self.get(id_or_key, &block)
        new.builder do
          path "issue/#{id_or_key}"
          instance_eval(&block) if block_given?
        end.run
      end

      def self.delete(id_or_key, &block)
        new.builder do
          path "issue/#{id_or_key}"
          method :delete
          instance_eval(&block) if block_given?
        end.run
      end

      singleton_class.alias_method :del, :delete

      def self.edit(id_or_key, &block)
        new.builder do
          path "issue/#{id_or_key}"
          method :put
          instance_eval(&block) if block_given?
        end.run
      end

      def self.comment(id_or_key, &block)
        Comment.create id_or_key, &block
      end

      def self.watchers(id_or_key, name, &block)
        new.builder do
          path "issue/#{id_or_key}/watchers"
          method :post
          data name.to_json
          instance_eval(&block) if block_given?
        end.run
      end

      def self.attachments(id_or_key, path, &block)
        Attachments.create id_or_key, path, &block
      end
    end
  end
end

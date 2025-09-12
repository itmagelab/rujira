# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/issue
    class Issue < Common
      def create(&block)
        builder do
          path 'issue'
          method :post
          instance_eval(&block) if block_given?
        end
        run
      end

      def get(id_or_key, &block)
        builder do
          path "issue/#{id_or_key}"
          instance_eval(&block) if block_given?
        end
        run
      end

      def delete(id_or_key, &block)
        builder do
          path "issue/#{id_or_key}"
          method :delete
          instance_eval(&block) if block_given?
        end
        run
      end

      alias del delete

      def edit(id_or_key, &block)
        builder do
          path "issue/#{id_or_key}"
          method :put
          instance_eval(&block) if block_given?
        end
        run
      end

      def comment(id_or_key, &block)
        @client.Comment.create id_or_key, &block
      end

      def watchers(id_or_key, name, &block)
        builder do
          path "issue/#{id_or_key}/watchers"
          method :post
          data name.to_json
          instance_eval(&block) if block_given?
        end
        run
      end

      def attachments(id_or_key, path, &block)
        @client.Attachments.create id_or_key, path, &block
      end
    end
  end
end

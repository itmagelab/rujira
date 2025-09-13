# frozen_string_literal: true

module Rujira
  module Api
    # TODO: add docs
    # Some description
    # https://docs.atlassian.com/jira-software/REST/9.17.0/#agile/1.0/sprint
    class Sprint < Common
      def initialize(client)
        super
        builder do
          rest_base 'rest/agile/1.0'
        end
      end

      def create(&block)
        builder do
          path 'sprint'
          headers 'Content-Type': 'application/json', Accept: 'application/json'
          method :post
          instance_eval(&block) if block_given?
        end
        run
      end

      def update(id, &block)
        abort 'Sprint ID is required' if id.to_s.strip.empty?
        raise ArgumentError, 'block is required' unless block

        builder do
          path "sprint/#{id}"
          headers 'Content-Type': 'application/json', Accept: 'application/json'
          method :post
          instance_eval(&block) if block_given?
        end
        run
      end

      def replace(id, &block)
        abort 'Sprint ID is required' if id.to_s.strip.empty?
        raise ArgumentError, 'block is required' unless block

        builder do
          path "sprint/#{id}"
          headers 'Content-Type': 'application/json', Accept: 'application/json'
          method :put
          instance_eval(&block) if block_given?
        end
        run
      end

      def get(id)
        abort 'Sprint ID is required' if id.to_s.strip.empty?
        builder do
          path "sprint/#{id}"
        end
        run
      end

      def get_issue(id)
        abort 'Sprint ID is required' if id.to_s.strip.empty?
        builder do
          path "sprint/#{id}/issue"
        end
        run
      end

      def delete(id)
        abort 'Sprint ID is required' if id.to_s.strip.empty?
        builder do
          method :delete
          path "sprint/#{id}"
        end
        run
      end

      def properties(id)
        abort 'Sprint ID is required' if id.to_s.strip.empty?
        builder do
          path "sprint/#{id}/properties"
        end
        run
      end

      def issue(id, issues)
        abort 'Sprint ID is required' if id.to_s.strip.empty?
        builder do
          method :post
          path "sprint/#{id}/issue"
          payload issues: issues
        end
        run
      end
    end
  end
end

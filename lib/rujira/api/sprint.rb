# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/jira-software/REST/9.17.0/#agile/1.0/sprint
    class Sprint < Common
      def initialize
        super
        @request.builder do
          rest_base 'rest/agile/1.0'
        end
      end

      def self.create(&block)
        new.builder do
          path 'sprint'
          headers 'Content-Type': 'application/json', Accept: 'application/json'
          method :post
          instance_eval(&block) if block_given?
        end.run
      end

      def self.update(id, &block)
        raise ArgumentError, 'block is required' unless block

        new.builder do
          path "sprint/#{id}"
          headers 'Content-Type': 'application/json', Accept: 'application/json'
          method :post
          instance_eval(&block) if block_given?
        end.run
      end

      def self.replace(id, &block)
        raise ArgumentError, 'block is required' unless block

        new.builder do
          path "sprint/#{id}"
          headers 'Content-Type': 'application/json', Accept: 'application/json'
          method :put
          instance_eval(&block) if block_given?
        end.run
      end

      def self.get(id)
        new.builder do
          path "sprint/#{id}"
        end.run
      end

      def self.get_issue(id)
        new.builder do
          path "sprint/#{id}/issue"
        end.run
      end

      def self.delete(id)
        new.builder do
          method :delete
          path "sprint/#{id}"
        end.run
      end

      def self.properties(id)
        new.builder do
          path "sprint/#{id}/properties"
        end.run
      end

      def self.issue(id, issues)
        new.builder do
          method :post
          path "sprint/#{id}/issue"
          payload issues: issues
        end.run
      end
    end
  end
end

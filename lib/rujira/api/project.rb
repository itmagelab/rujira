# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/project
    class Project < Common
      def self.create(&block)
        new.builder do
          path 'project'
          method :post
          instance_eval(&block) if block_given?
        end.run
      end

      def self.edit(id_or_key, &block)
        new.builder do
          path "project/#{id_or_key}"
          method :put
          instance_eval(&block) if block_given?
        end.run
      end

      def self.get(id_or_key, &block)
        new.builder do
          path "project/#{id_or_key}"
          instance_eval(&block) if block_given?
        end.run
      end

      def self.securitylevel(id_or_key, &block)
        new.builder do
          path "project/#{id_or_key}/securitylevel"
          instance_eval(&block) if block_given?
        end.run
      end
    end
  end
end

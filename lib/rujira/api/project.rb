# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/project
    class Project < Common
      def create(&block)
        builder do
          path 'project'
          method :post
          instance_eval(&block) if block_given?
        end
        run
      end

      def edit(id_or_key, &block)
        abort 'Project ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "project/#{id_or_key}"
          method :put
          instance_eval(&block) if block_given?
        end
        run
      end

      def get(id_or_key, &block)
        abort 'Project ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "project/#{id_or_key}"
          instance_eval(&block) if block_given?
        end
        run
      end

      def list(&block)
        builder do
          path 'project'
          instance_eval(&block) if block_given?
        end
        run
      end

      def delete(id_or_key)
        abort 'Project ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          method :delete
          path "project/#{id_or_key}"
        end
        run
      end

      def securitylevel(id_or_key, &block)
        abort 'Project ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "project/#{id_or_key}/securitylevel"
          instance_eval(&block) if block_given?
        end
        run
      end
    end
  end
end

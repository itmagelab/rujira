# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    # https://docs.atlassian.com/software/jira/docs/api/REST/8.17.1/#api/2/project
    class Project < Item
      def self.create(&block)
        entity = Entity.build do
          path 'project'
          method :POST
          instance_eval(&block) if block_given?
        end
        new(entity.commit)
      end

      def self.get(id_or_key, &block)
        entity = Entity.build do
          path "project/#{id_or_key}"
          instance_eval(&block) if block_given?
        end
        new(entity.commit)
      end

      def self.securitylevel(id_or_key, &block)
        entity = Entity.build do
          path "project/#{id_or_key}/securitylevel"
          instance_eval(&block) if block_given?
        end
        new(entity.commit)
      end
    end
  end
end

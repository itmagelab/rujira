# frozen_string_literal: true

module Rujira
  module Api
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/issuetype
    #
    class IssueType < Common
      def get(&block)
        builder do
          path 'issuetype'
          method :get
          instance_eval(&block) if block_given?
        end
        call
      end

      def get_by_name(name, &block)
        issue_types = get(&block)
        issue_types.find { |type| type.name == name }
      end
    end
  end
end

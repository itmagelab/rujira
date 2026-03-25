# frozen_string_literal: true

module Rujira
  module Resource
    # Represents a Jira issue resource.
    # Provides access to issue attributes and actions such as adding comments.
    #
    # Example usage:
    #   issue = Rujira::Resource::User.new(client, data)
    #   issue.add_comment("This is a comment")
    #
    class User < Common
      # @return [String] The URL to access this issue via Jira REST API
      attr_reader :url
      # @return [String] The key of the issue (e.g., "TEST-123")
      attr_reader :key
      attr_reader :name, :email, :display_name, :active

      # Initializes an User resource
      #
      # @param [Object] client The API client instance used to make requests
      # @param [Hash] hash The issue data from the Jira API
      def initialize(client, **args)
        super

        @url = args['self']
        @key = args['key']
        @name = args['name']
        @email = args['emailAddress']
        @display_name = args['displayName']
        @active = args.fetch('active', true)
        @deleted = args.fetch('deleted', false)
      end

      def delete
        @client.User.delete(@key)
      end

      def update(&block)
        @client.User.update(@key) do
          instance_eval(&block) if block_given?
        end
        reload!
      end

      def deactivate!
        @client.User.update(@key) do
          payload active: false
        end
        reload!
      end

      def activate!
        @client.User.update(@key) do
          payload active: true
        end
        reload!
      end
    end
  end
end

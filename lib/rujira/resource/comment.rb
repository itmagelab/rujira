# frozen_string_literal: true

module Rujira
  module Resource
    # Represents a Jira comment resource.
    # Provides access to comment attributes and actions such as deletion.
    #
    # Example usage:
    #   comment = Rujira::Resource::Comment.new(client, data)
    #   comment.delete  # Deletes the comment via the API
    #
    class Comment < Common
      # @return [String] The ID of the comment
      attr_reader :id
      # @return [String] The issue key or resource key associated with the comment
      attr_reader :key
      # @return [String] The URL to access this comment via Jira REST API
      attr_reader :url

      # Initializes a Comment resource
      #
      # @param [Object] client The API client instance used to make requests
      # @param [Hash] hash The comment data from the Jira API
      def initialize(client, **args)
        super

        @url = args['self']
        @id = args['id']

        @author = args['author']
        @body = args['body']
        @update_author = args['updateAuthor']
        @created = args['created']
        @updated = args['updated']

        @parent = args[:parent] # The parent issue key or resource
      end

      # Deletes this comment from Jira.
      #
      # @return [Object] The API response from the delete operation
      #
      # @example Delete a comment
      #   comment.delete
      def delete
        @client.Comment.delete(@parent, @id)
      end
    end
  end
end

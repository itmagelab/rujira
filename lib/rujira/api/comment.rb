# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira issue comments via the REST API.
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/comment/%7BcommentId%7D/properties
    #
    class Comment < Common
      # Creates a new comment for the specified Jira issue.
      #
      # @param [String] id_or_key The issue ID or key where the comment will be added.
      # @yield [builder] Optional block to customize the request payload (e.g., setting comment body).
      # @return [Object] The API response containing the created comment.
      #
      # @example Create a comment with body text
      #   client.Comment.create("ISSUE-123") do
      #     payload body: "This is a test comment"
      #   end
      #
      def create(id_or_key, &block)
        owned_by id_or_key

        abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "issue/#{id_or_key}/comment"
          method :post
          instance_eval(&block) if block_given?
        end
        call
      end

      # Deletes a comment from an issue.
      #
      # @param [String] id_or_key The issue ID or key.
      # @param [String] id The comment ID.
      # @yield [builder] Optional block to configure additional request parameters.
      # @return [Object] The API response after deleting the comment.
      #
      # @example Delete a comment
      #   client.Issue.delete_comment("TEST-123", "10001")
      #
      def delete(id_or_key, id, &block)
        abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "issue/#{id_or_key}/comment/#{id}"
          method :delete
          instance_eval(&block) if block_given?
        end
        call
      end
    end
  end
end

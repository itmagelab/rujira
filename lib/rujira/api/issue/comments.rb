# frozen_string_literal: true

module Rujira
  module Api
    class Issue < Common
      # Module providing methods to manage comments on Jira issues.
      #
      # This module is included in the `Issue` class and allows you to:
      # - Add a new comment to an issue
      # - Retrieve a specific comment
      # - Update a comment
      # - Delete a comment
      # - Pin a comment
      # - Retrieve pinned comments
      #
      # All methods support an optional block to customize the request using the
      # builder DSL, e.g., adding headers, query parameters, or payloads.
      #
      # @example Add a comment to an issue
      #   client.Issue.add_comment("TEST-123") do
      #     payload({ body: "This is a comment" })
      #   end
      #
      # @example Update a comment
      #   client.Issue.update_comment("TEST-123", "10001") do
      #     payload({ body: "Updated comment text" })
      #   end
      #
      # @example Delete a comment
      #   client.Issue.delete_comment("TEST-123", "10001")
      #
      # @example Get a pinned comment
      #   client.Issue.get_pinned_comment("TEST-123")
      #
      # @example Pin a comment
      #   client.Issue.pin_comment("TEST-123", "10001")
      module Comments
        # Retrieves comments for a given issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @yield [builder] Optional block to configure additional request parameters.
        # @return [Object] The API response containing the issue's comments.
        #
        # @example Get comments for an issue
        #   client.Issue.comment("TEST-123") do
        #     # Optional: add query parameters or headers
        #     params startAt: 0, maxResults: 50
        #   end
        #
        def list_comment(id_or_key, &block)
          abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
          builder do
            path "issue/#{id_or_key}/comment"
            method :get
            instance_eval(&block) if block_given?
          end
          call
        end

        # Adds a comment to a given issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @yield [builder] Block to configure the payload for the new comment.
        # @return [Object] The API response after adding the comment.
        #
        # @example Add a comment to an issue
        #   client.Issue.add_comment("TEST-123") do
        #     payload body: "This is a new comment added via the API."
        #   end
        def add_comment(id_or_key, &block)
          abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
          builder do
            path "issue/#{id_or_key}/comment"
            method :post
            instance_eval(&block) if block_given?
          end
          call
        end

        # Updates an existing comment on a given issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @param [String] id The comment ID.
        # @yield [builder] Block to configure the payload for updating the comment.
        # @return [Object] The API response after updating the comment.
        #
        # @example Update a comment on an issue
        #   client.Issue.update_comment("TEST-123", "10001") do
        #     payload body: "Updated comment content."
        #   end
        def update_comment(id_or_key, id, &block)
          abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
          builder do
            path "issue/#{id_or_key}/comment/#{id}"
            method :put
            instance_eval(&block) if block_given?
          end
          call
        end

        # Deletes a comment from a given issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @param [String] id The comment ID.
        # @yield [builder] Optional block to configure additional request parameters.
        # @return [Object] The API response after deleting the comment.
        #
        # @example Delete a comment from an issue
        #   client.Issue.delete_comment("TEST-123", "10001") do
        #     # Optional: add headers or query parameters if needed
        #   end
        def delete_comment(id_or_key, id, &block)
          abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
          builder do
            path "issue/#{id_or_key}/comment/#{id}"
            method :delete
            instance_eval(&block) if block_given?
          end
          call
        end

        # Retrieves a specific comment from a given issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @param [String] id The comment ID.
        # @yield [builder] Optional block to configure additional request parameters.
        # @return [Object] The API response containing the comment details.
        #
        # @example Get a specific comment
        #   client.Issue.get_comment("TEST-123", "10001") do
        #     # Optional: add headers or query parameters if needed
        #   end
        #
        def get_comment(id_or_key, id, &block)
          abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
          builder do
            path "issue/#{id_or_key}/comment/#{id}"
            instance_eval(&block) if block_given?
          end
          call
        end

        # Pins a comment on a given issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @param [String] id The comment ID.
        # @yield [builder] Optional block to configure additional request parameters.
        # @return [Object] The API response after pinning the comment.
        #
        # @example Pin a comment
        #   client.Issue.pin_comment("TEST-123", "10001") do
        #     # Optional: add headers or query parameters if needed
        #   end
        #
        def pin_comment(id_or_key, id, &block)
          abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
          builder do
            method :put
            path "issue/#{id_or_key}/comment/#{id}/pin"
            instance_eval(&block) if block_given?
          end
          call
        end

        # Adds a comment to an issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @yield [builder] Optional block to configure the comment payload.
        # @return [Object] The API response containing the created comment.
        #
        # @example Add a comment
        #   client.Issue.comment("TEST-123") do
        #     payload body: "This is a comment"
        #   end
        #
        def comment(id_or_key, &block)
          abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
          @client.Comment.create id_or_key, &block
        end

        # Retrieves the pinned comment(s) for a given issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @yield [builder] Optional block to configure additional request parameters.
        # @return [Object] The API response containing the pinned comment(s).
        #
        # @example Get pinned comments for an issue
        #   client.Issue.get_pinned_comment("TEST-123") do
        #     # Optional: add query parameters or headers
        #     params expand: "renderedBody"
        #   end
        def get_pinned_comments(id_or_key, &block)
          abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
          builder do
            path "issue/#{id_or_key}/pinned-comments"
            instance_eval(&block) if block_given?
          end
          call
        end
      end
    end
  end
end

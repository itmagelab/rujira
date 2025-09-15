# frozen_string_literal: true

require_relative 'issue/watchers'
require_relative 'issue/comments'

module Rujira
  module Api
    # Provides access to Jira issues via the REST API.
    # Includes support for creating, updating, deleting, archiving issues,
    # managing assignees, comments, remote links, transitions, watchers, and attachments.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/issue
    #
    class Issue < Common # rubocop:disable Metrics/ClassLength
      include Watchers
      include Comments

      # Creates a new issue.
      #
      # @yield [builder] Optional block to configure payload (fields, description, etc.).
      # @return [Object] The API response containing the created issue.
      # @example
      #   client.Issue.create do
      #     payload fields: { summary: "New bug", issuetype: { name: 'Task' }, project: { key: "TEST" } }
      #   end
      #
      def create(&block)
        builder do
          path 'issue'
          method :post
          instance_eval(&block) if block_given?
        end
        call
      end

      # Creates multiple issues in bulk.
      #
      # @yield [builder] Block to configure bulk payload.
      # @return [Object] API response after creating issues.
      # @example
      #   client.Issue.create_bulk do
      #     payload issues: [{ fields: { summary: "Issue 1", project: { key: "TEST" }, issuetype: { name: "Task" } } }]
      #   end
      #
      def create_bulk(&block)
        builder do
          path 'issue/bulk'
          method :post
          instance_eval(&block) if block_given?
        end
        call
      end

      # Retrieves an issue by ID or key.
      #
      # @param [String] id_or_key The issue ID or key.
      # @yield [builder] Optional block to configure additional request parameters or headers.
      # @return [Object] The API response containing issue details.
      # @example
      #   client.Issue.get("TEST-123")
      def get(id_or_key, &block)
        abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "issue/#{id_or_key}"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Deletes an issue by ID or key.
      #
      # @param [String] id_or_key The issue ID or key.
      # @yield [builder] Optional block to configure additional request parameters.
      # @return [Object] API response after deletion.
      def delete(id_or_key, &block)
        abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "issue/#{id_or_key}"
          method :delete
          instance_eval(&block) if block_given?
        end
        call
      end
      alias del delete

      # Updates an existing issue.
      #
      # @param [String] id_or_key The issue ID or key.
      # @yield [builder] Optional block to configure the update payload.
      # @return [Object] API response after updating.
      def edit(id_or_key, &block)
        abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "issue/#{id_or_key}"
          method :put
          instance_eval(&block) if block_given?
        end
        call
      end

      # Archives an issue.
      #
      # @param [String] id_or_key The issue ID or key.
      # @yield [builder] Optional block for additional params.
      # @return [Object] API response after archiving.
      def archive(id_or_key, &block)
        abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "issue/#{id_or_key}/archive"
          method :put
          instance_eval(&block) if block_given?
        end
        call
      end

      # Lists archived information of an issue.
      #
      # @param [String] id_or_key The issue ID or key.
      # @yield [builder] Optional block to add query parameters.
      # @return [Object] API response with archive details.
      def list_archive(id_or_key, &block)
        abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "issue/#{id_or_key}/archive"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Updates the assignee of an issue.
      #
      # @param [String] id_or_key Issue ID or key.
      # @yield [builder] Block to configure assignee payload.
      # @return [Object] API response after assignment.
      def assignee(id_or_key, &block)
        abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "issue/#{id_or_key}/assignee"
          method :put
          instance_eval(&block) if block_given?
        end
        call
      end

      # Retrieves edit metadata for an issue.
      #
      # @param [String] id_or_key Issue ID or key.
      # @yield [builder] Optional block to configure query parameters.
      # @return [Object] API response with editable fields and constraints.
      def editmeta(id_or_key, &block)
        abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "issue/#{id_or_key}/editmeta"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Sends a notification about an issue.
      #
      # @param [String] id_or_key Issue ID or key.
      # @yield [builder] Block to configure notification payload.
      # @return [Object] API response after sending notification.
      def notify(id_or_key, &block)
        abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          method :post
          path "issue/#{id_or_key}/notify"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Uploads an attachment to an issue.
      #
      # @param [String] id_or_key Issue ID or key.
      # @param [String] path Local path to file.
      # @yield [builder] Optional block to configure request.
      # @return [Object] API response after attachment.
      def create_attachments(id_or_key, path, &block)
        abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
        client = @client
        builder do
          path "issue/#{id_or_key}/attachments"
          method :post
          headers 'X-Atlassian-Token': 'no-check'
          payload file: client.file(path)
          instance_eval(&block) if block_given?
        end
        call
      end
      alias attachments create_attachments

      # Performs a transition on an issue.
      #
      # @param [String] id_or_key Issue ID or key.
      # @yield [builder] Block to configure transition payload.
      # @return [Object] API response after transition.
      def transitions(id_or_key, &block)
        abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          method :post
          path "issue/#{id_or_key}/transitions"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Retrieves available transitions for an issue.
      #
      # @param [String] id_or_key Issue ID or key.
      # @yield [builder] Optional block to add query parameters.
      # @return [Object] API response with available transitions.
      def get_transitions(id_or_key, &block)
        abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "issue/#{id_or_key}/transitions"
          instance_eval(&block) if block_given?
        end
        call
      end

      # NOTE: Watchers and Comments modules are included separately.
    end
  end
end

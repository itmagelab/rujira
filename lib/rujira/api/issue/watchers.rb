# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira issues via the REST API.
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/issue
    #
    class Issue < Common
      # Module providing methods to manage watchers on Jira issues.
      #
      # This module is included in the `Issue` class and allows you to:
      # - Retrieve the list of watchers for an issue
      # - Add watchers to an issue
      # - Remove watchers from an issue
      #
      # All methods support an optional block to customize the request using the
      # builder DSL, e.g., adding headers, query parameters, or payloads.
      #
      # @example Get all watchers for an issue
      #   client.Issue.get_watchers("TEST-123")
      #
      # @example Add watchers to an issue
      #   client.Issue.add_watchers("TEST-123") do
      #     payload ["john.doe", "jane.smith"]
      #   end
      #
      # @example Remove a watcher from an issue
      #   client.Issue.remove_watchers("TEST-123", "john.doe")
      module Watchers
        # Removes a watcher from a given issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @param [String] username The username of the watcher to remove.
        # @yield [builder] Optional block to configure additional request parameters.
        # @return [Object] The API response after removing the watcher.
        #
        # @example Remove a watcher from an issue
        #   client.Issue.remove_watchers("TEST-123", "john.doe") do
        #     # Optional: add headers or query parameters
        #   end
        def remove_watchers(id_or_key, username, &block)
          abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
          abort 'USERNAME is required' if username.to_s.strip.empty?
          builder do
            method :delete
            path "issue/#{id_or_key}/watchers"
            params username: username
            instance_eval(&block) if block_given?
          end
          run
        end

        # Retrieves the list of watchers for a given issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @yield [builder] Optional block to configure additional request parameters.
        # @return [Object] The API response containing the list of watchers.
        #
        # @example Get watchers of an issue
        #   client.Issue.get_watchers("TEST-123") do
        #     # Optional: add query parameters or headers
        #   end
        def get_watchers(id_or_key, &block)
          abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
          builder do
            path "issue/#{id_or_key}/watchers"
            instance_eval(&block) if block_given?
          end
          run
        end

        # Adds watchers to a given issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @yield [builder] Block to configure the payload for adding watchers.
        # @return [Object] The API response after adding watchers.
        #
        # @example Add watchers to an issue
        #   client.Issue.add_watchers("TEST-123") do
        #     payload ["john.doe", "jane.smith"]
        #   end
        def add_watchers(id_or_key, &block)
          abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
          builder do
            method :post
            path "issue/#{id_or_key}/watchers"
            instance_eval(&block) if block_given?
          end
          run
        end

        # Adds a watcher to an issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @param [String] name The username to add as a watcher.
        # @yield [builder] Optional block to configure the request.
        # @return [Object] The API response after adding the watcher.
        #
        # @example Add a watcher
        #   client.Issue.watchers("TEST-123", "johndoe")
        #
        def watcher(id_or_key, name, &block)
          abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
          builder do
            path "issue/#{id_or_key}/watchers"
            method :post
            payload name.to_json
            instance_eval(&block) if block_given?
          end
          run
        end
      end
    end
  end
end

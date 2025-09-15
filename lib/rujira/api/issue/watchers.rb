# frozen_string_literal: true

module Rujira
  module Api
    class Issue < Common
      # Module providing methods to manage watchers on Jira issues.
      #
      # This module is included in the `Issue` class and allows you to:
      # - Retrieve the list of watchers for an issue
      # - Add single or multiple watchers to an issue
      # - Remove watchers from an issue
      #
      # All methods support an optional block to customize the request using the
      # builder DSL (headers, query parameters, or payload).
      #
      # @example Get all watchers for an issue
      #   client.Issue.get_watchers("TEST-123")
      #
      # @example Add multiple watchers to an issue
      #   client.Issue.add_watchers("TEST-123") do
      #     payload ["john.doe", "jane.smith"]
      #   end
      #
      # @example Add a single watcher to an issue
      #   client.Issue.watcher("TEST-123", "john.doe")
      #
      # @example Remove a watcher from an issue
      #   client.Issue.remove_watchers("TEST-123", "john.doe")
      module Watchers
        # Retrieves the list of watchers for a specific issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @yield [builder] Optional block to customize headers, query parameters, or other request options.
        # @return [Object] The API response containing the watchers.
        #
        # @example Retrieve watchers
        #   client.Issue.get_watchers("TEST-123")
        def get_watchers(id_or_key, &block)
          abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
          builder do
            path "issue/#{id_or_key}/watchers"
            instance_eval(&block) if block_given?
          end
          call
        end

        # Adds multiple watchers to a specific issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @yield [builder] Block to configure the request payload (array of usernames).
        # @return [Object] The API response after adding watchers.
        #
        # @example Add multiple watchers
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
          call
        end

        # Adds a single watcher to a specific issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @param [String] username The username of the watcher to add.
        # @yield [builder] Optional block to customize the request.
        # @return [Object] The API response after adding the watcher.
        #
        # @example Add a single watcher
        #   client.Issue.watcher("TEST-123", "john.doe")
        def watcher(id_or_key, username, &block)
          abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
          abort 'USERNAME is required' if username.to_s.strip.empty?
          builder do
            path "issue/#{id_or_key}/watchers"
            method :post
            payload username.to_json
            instance_eval(&block) if block_given?
          end
          call
        end

        # Removes a watcher from a specific issue.
        #
        # @param [String] id_or_key The issue ID or key.
        # @param [String] username The username of the watcher to remove.
        # @yield [builder] Optional block to customize headers, query parameters, or other request options.
        # @return [Object] The API response after removing the watcher.
        #
        # @example Remove a watcher
        #   client.Issue.remove_watchers("TEST-123", "john.doe")
        def remove_watchers(id_or_key, username, &block)
          abort 'Issue ID or KEY is required' if id_or_key.to_s.strip.empty?
          abort 'USERNAME is required' if username.to_s.strip.empty?
          builder do
            method :delete
            path "issue/#{id_or_key}/watchers"
            params username: username
            instance_eval(&block) if block_given?
          end
          call
        end
      end
    end
  end
end

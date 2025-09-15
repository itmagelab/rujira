# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira filters via the REST API.
    # Allows creating, editing, deleting, retrieving filters,
    # managing filter columns, permissions, and favorite/default settings.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/filter
    #
    class Filter < Common
      # Creates a new filter.
      #
      # @yield [builder] Block to configure the payload for the new filter.
      # @return [Object] The API response after creating the filter.
      #
      # @example Create a filter
      #   client.Filter.create do
      #     payload name: "My Filter", jql: "project = TEST", favourite: true
      #   end
      #
      def create(&block)
        builder do
          method :post
          path 'filter'
          instance_eval(&block) if block_given?
        end
        call
      end

      # Updates an existing filter by ID.
      #
      # @param [String] id The filter ID.
      # @yield [builder] Block to configure the payload for update.
      # @return [Object] The API response after editing the filter.
      #
      # @example Edit a filter
      #   client.Filter.edit("10001") do
      #     payload name: "Updated Filter Name"
      #   end
      #
      def edit(id, &block)
        builder do
          method :put
          path "filter/#{id}"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Deletes a filter by ID.
      #
      # @param [String] id The filter ID.
      # @return [Object] The API response after deletion.
      #
      def delete(id)
        builder do
          method :delete
          path "filter/#{id}"
        end
        call
      end

      # Retrieves a filter by ID.
      #
      # @param [String] id The filter ID.
      # @return [Object] The API response containing filter details.
      #
      def get(id)
        builder do
          path "filter/#{id}"
        end
        call
      end

      # Retrieves columns configuration of a filter.
      #
      # @param [String] id The filter ID.
      # @return [Object] The API response with columns configuration.
      #
      def columns(id)
        builder do
          path "filter/#{id}/columns"
        end
        call
      end

      # Updates columns configuration of a filter.
      #
      # @param [String] id The filter ID.
      # @yield [builder] Block to configure the payload for columns.
      # @return [Object] The API response after updating columns.
      #
      # @example Set columns for a filter
      #   client.Filter.set_columns("10001") do
      #     payload ["summary", "assignee", "status"]
      #   end
      #
      def set_columns(id, &block)
        builder do
          method :put
          path "filter/#{id}/columns"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Resets columns of a filter to default.
      #
      # @param [String] id The filter ID.
      # @return [Object] The API response after resetting columns.
      #
      def reset_columns(id)
        builder do
          method :delete
          path "filter/#{id}/columns"
        end
        call
      end

      # Lists permissions of a filter.
      #
      # @param [String] id The filter ID.
      # @return [Object] The API response containing permissions.
      #
      def list_permission(id)
        builder do
          path "filter/#{id}/permission"
        end
        call
      end

      # Adds a permission to a filter.
      #
      # @param [String] id The filter ID.
      # @yield [builder] Block to configure the permission payload.
      # @return [Object] The API response after adding permission.
      #
      # @example Add permission to a filter
      #   client.Filter.add_permission("10001") do
      #     payload type: "group", groupname: "jira-users"
      #   end
      #
      def add_permission(id, &block)
        builder do
          method :post
          path "filter/#{id}/permission"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Retrieves a specific permission of a filter.
      #
      # @param [String] id The filter ID.
      # @param [String] permission_id The permission ID.
      # @return [Object] The API response containing the permission details.
      #
      def permission(id, permission_id)
        builder do
          path "filter/#{id}/permission/#{permission_id}"
        end
        call
      end

      # Deletes a specific permission of a filter.
      #
      # @param [String] id The filter ID.
      # @param [String] permission_id The permission ID.
      # @return [Object] The API response after deletion.
      #
      def delete_permission(id, permission_id)
        builder do
          method :delete
          path "filter/#{id}/permission/#{permission_id}"
        end
        call
      end

      # Retrieves the default share scope of filters.
      #
      # @return [Object] The API response with default share scope.
      #
      def default_share_scope
        builder do
          path 'filter/defaultShareScope'
        end
        call
      end

      # Updates the default share scope of filters.
      #
      # @yield [builder] Block to configure the payload.
      # @return [Object] The API response after updating default share scope.
      #
      # @example Set default share scope
      #   client.Filter.set_default_share_scope do
      #     payload type: "PROJECT", projectId: "10000"
      #   end
      #
      def set_default_share_scope(&block)
        builder do
          method :put
          path 'filter/defaultShareScope'
          instance_eval(&block) if block_given?
        end
        call
      end

      # Retrieves favorite filters.
      #
      # @return [Object] The API response containing favorite filters.
      #
      def favourite
        builder do
          path 'filter/favourite'
        end
        call
      end
    end
  end
end

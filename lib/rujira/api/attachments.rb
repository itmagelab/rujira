# frozen_string_literal: true

module Rujira
  module Api
    # Provides methods to manage Jira issue attachments via the REST API.
    # Supports retrieving, deleting, and accessing metadata of attachments.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/attachment
    #
    class Attachments < Common
      # Retrieves a specific attachment by ID.
      #
      # @param [String] id The attachment ID.
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing attachment details.
      #
      # @example Get an attachment
      #   client.Attachments.get("10001")
      #
      def get(id, &block)
        abort 'Attachment ID is required' if id.to_s.strip.empty?
        builder do
          path "attachment/#{id}"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Deletes a specific attachment by ID.
      #
      # @param [String] id The attachment ID.
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response after deletion.
      #
      # @example Delete an attachment
      #   client.Attachments.delete("10001")
      #
      def delete(id, &block)
        abort 'Attachment ID is required' if id.to_s.strip.empty?
        builder do
          method :delete
          path "attachment/#{id}"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Retrieves metadata for attachments.
      #
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing attachment metadata.
      #
      # @example Get attachment metadata
      #   client.Attachments.meta
      #
      def meta(&block)
        builder do
          path 'attachment/meta'
          instance_eval(&block) if block_given?
        end
        call
      end
    end
  end
end

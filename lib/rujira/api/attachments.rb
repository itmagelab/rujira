# frozen_string_literal: true

module Rujira
  module Api
    # This class provides methods to manage Jira issue attachments via the REST API.
    # Currently, it supports creating (uploading) attachments for a given issue ID or key.
    # Example: Attach a file to an issue by calling `create("ISSUE-123", "/path/to/file")`.
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/issue/%7BissueIdOrKey%7D/attachments
    class Attachments < Common
      # Retrieves a specific attachment by ID.
      #
      # @param [String] id The attachment ID.
      # @return [Object] The API response containing attachment details.
      #
      # @example Get an attachment
      #   client.attachments.get("10001")
      #
      def get(id)
        abort 'Attachment ID is required' if id.to_s.strip.empty?
        builder do
          path "attachment/#{id}"
        end
        run
      end

      # Deletes a specific attachment by ID.
      #
      # @param [String] id The attachment ID.
      # @return [Object] The API response after deletion.
      #
      # @example Delete an attachment
      #   client.attachments.delete("10001")
      #
      def delete(id)
        abort 'Attachment ID is required' if id.to_s.strip.empty?
        builder do
          method :delete
          path "attachment/#{id}"
        end
        run
      end

      # Retrieves metadata for attachments.
      #
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing attachment metadata.
      #
      # @example Get attachment metadata
      #   client.attachments.meta
      #
      def meta
        builder do
          path 'attachment/meta'
        end
        run
      end
    end
  end
end

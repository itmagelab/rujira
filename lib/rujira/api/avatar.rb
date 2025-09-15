# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira avatars via the REST API.
    # Allows retrieving system avatars, uploading temporary avatars, and cropping them.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/avatar
    #
    class Avatar < Common
      # Retrieves all system avatars of a given type.
      #
      # @param [String] type The type of avatar (e.g., "project", "user").
      # @return [Object] The API response containing system avatars.
      #
      # @example Get system avatars for projects
      #   client.Avatar.get("project")
      #
      def get(type)
        builder do
          path "avatar/#{type}/system"
        end
        call
      end

      # Uploads a temporary avatar for a given type.
      #
      # @param [String] type The type of avatar (e.g., "project", "user").
      # @yield [builder] Block to configure the payload, usually including the file.
      # @return [Object] The API response after uploading the temporary avatar.
      #
      # @example Upload a temporary avatar
      #   client.Avatar.store("project") do
      #     payload file: client.file("/path/to/avatar.png")
      #   end
      #
      def store(type, &block)
        builder do
          method :post
          path "avatar/#{type}/temporary"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Crops a previously uploaded temporary avatar.
      #
      # @param [String] type The type of avatar (e.g., "project", "user").
      # @yield [builder] Block to configure crop parameters.
      # @return [Object] The API response after cropping the avatar.
      #
      # @example Crop a temporary avatar
      #   client.Avatar.crop("project") do
      #     payload { x: 0, y: 0, width: 48, height: 48 }
      #   end
      #
      def crop(type, &block)
        builder do
          method :post
          path "avatar/#{type}/temporaryCrop"
          instance_eval(&block) if block_given?
        end
        call
      end
    end
  end
end

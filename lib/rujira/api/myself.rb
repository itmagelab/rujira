# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to the Jira "Myself" resource via the REST API.
    # Allows retrieving details about the currently authenticated user.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/myself
    #
    class Myself < Common
      # Retrieves details of the currently authenticated user.
      #
      # @return [Object] The API response containing user details.
      #
      # @example Get current user details
      #   client.Myself.get
      #
      def get(&block)
        builder do
          path 'myself'
          instance_eval(&block) if block_given?
        end
        call
      end

      # Updates the current user's profile.
      #
      # @yield [builder] Block to configure the payload or additional request parameters.
      # @return [Object] The API response after updating the user profile.
      #
      # @example Update user profile
      #   client.Myself.update do
      #     payload({ displayName: "New Name", emailAddress: "new@example.com" })
      #   end
      def update(&block)
        builder do
          method :put
          path 'myself'
          instance_eval(&block) if block_given?
        end
        call
      end

      # Changes the current user's password.
      #
      # @yield [builder] Block to configure the payload for the password change.
      # @return [Object] The API response after changing the password.
      #
      # @example Change user password
      #   client.Myself.password do
      #     payload({ password: "newpassword123" })
      #   end
      def password(&block)
        builder do
          method :put
          path 'myself'
          instance_eval(&block) if block_given?
        end
        call
      end
    end
  end
end

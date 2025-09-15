# frozen_string_literal: true

module Rujira
  module Api
    # Provides access to Jira projects via the REST API.
    # Allows creating, updating, retrieving, listing, and deleting projects,
    # as well as retrieving project security levels.
    #
    # API reference:
    # https://docs.atlassian.com/software/jira/docs/api/REST/9.17.0/#api/2/project
    #
    class Project < Common
      # Creates a new project.
      #
      # @yield [builder] Optional block to configure the request payload.
      # @return [Object] The API response containing the created project.
      #
      # @example Create a project
      #   client.Project.create do
      #     payload({
      #       key: "TEST",
      #       name: "Test Project",
      #       projectTypeKey: "software",
      #       projectTemplateKey: "com.atlassian.jira-core-project-templates:jira-core-project-management"
      #     })
      #   end
      def create(&block)
        builder do
          path 'project'
          method :post
          instance_eval(&block) if block_given?
        end
        call
      end

      # Updates an existing project.
      #
      # @param [String] id_or_key The project ID or key.
      # @yield [builder] Optional block to configure the update payload.
      # @return [Object] The API response after updating the project.
      #
      # @example Update a project
      #   client.Project.edit("TEST") do
      #     payload({ name: "Renamed Project" })
      #   end
      def edit(id_or_key, &block)
        abort 'Project ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "project/#{id_or_key}"
          method :put
          instance_eval(&block) if block_given?
        end
        call
      end

      # Retrieves a specific project by ID or key.
      #
      # @param [String] id_or_key The project ID or key.
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing project details.
      #
      # @example Get a project
      #   client.Project.get("TEST")
      def get(id_or_key, &block)
        abort 'Project ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "project/#{id_or_key}"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Lists all projects visible to the current user.
      #
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing the list of projects.
      #
      # @example List projects
      #   client.Project.list
      def list(&block)
        builder do
          path 'project'
          instance_eval(&block) if block_given?
        end
        call
      end

      # Deletes a project by ID or key.
      #
      # @param [String] id_or_key The project ID or key.
      # @yield [builder] Optional block to configure additional request parameters.
      # @return [Object] The API response after deletion.
      #
      # @example Delete a project
      #   client.Project.delete("TEST")
      def delete(id_or_key, &block)
        abort 'Project ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          method :delete
          path "project/#{id_or_key}"
          instance_eval(&block) if block_given?
        end
        call
      end

      # Retrieves the security levels for a specific project.
      #
      # @param [String] id_or_key The project ID or key.
      # @yield [builder] Optional block to configure the request.
      # @return [Object] The API response containing security levels.
      #
      # @example Get project security levels
      #   client.Project.securitylevel("TEST")
      def securitylevel(id_or_key, &block)
        abort 'Project ID or KEY is required' if id_or_key.to_s.strip.empty?
        builder do
          path "project/#{id_or_key}/securitylevel"
          instance_eval(&block) if block_given?
        end
        call
      end
    end
  end
end

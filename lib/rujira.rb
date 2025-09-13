# frozen_string_literal: true

# Load Rake tasks if Rake is defined
Dir[File.join(__dir__, 'rujira', 'tasks', '*.rake')].each { |r| load r } if defined?(Rake)

require 'faraday'
require 'faraday/multipart'
require 'json'

require_relative 'rujira/error'
require_relative 'rujira/version'
require_relative 'rujira/request'
require_relative 'rujira/client'
require_relative 'rujira/api/common'
require_relative 'rujira/api/search'
require_relative 'rujira/api/issue'
require_relative 'rujira/api/project'
require_relative 'rujira/api/comment'
require_relative 'rujira/api/attachments'
require_relative 'rujira/api/myself'
require_relative 'rujira/api/server_info'
require_relative 'rujira/api/dashboard'
require_relative 'rujira/api/board'
require_relative 'rujira/api/sprint'

# Main Rujira module.
# Serves as the namespace for the Jira SDK.
#
# Provides utility methods and custom error handling.
#
module Rujira
  # Custom error class for Rujira SDK
  #
  # @example
  #   raise Rujira::Error, "Something went wrong"
  #
  class Error < StandardError; end

  # Checks if an environment variable is truthy.
  #
  # @param [String] var The name of the environment variable
  # @return [Boolean] true if the value is 'true', '1', or 'yes' (case-insensitive), false otherwise
  #
  # @example Check if debug mode is enabled
  #   Rujira.env_var?('RUJIRA_DEBUG')
  #
  def self.env_var?(var)
    %w[true 1 yes].include?(ENV[var]&.downcase)
  end
end

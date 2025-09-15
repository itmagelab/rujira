# frozen_string_literal: true

# Load Rake tasks if Rake is defined
Dir[File.join(__dir__, 'rujira', 'tasks', '*.rake')].each { |r| load r } if defined?(Rake)

require 'faraday'
require 'faraday/multipart'
require 'json'

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
require_relative 'rujira/api/permissions'
require_relative 'rujira/api/application_properties'
require_relative 'rujira/api/applicationrole'
require_relative 'rujira/api/avatar'
require_relative 'rujira/api/configuration'
require_relative 'rujira/api/custom_fields'
require_relative 'rujira/api/field'
require_relative 'rujira/api/filter'

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
end

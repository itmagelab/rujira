# frozen_string_literal: true

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

# TODO: add docs
# Some description
module Rujira
  class Error < StandardError; end

  def self.env_var?(var)
    %w[true 1 yes].include?(ENV[var]&.downcase)
  end
end

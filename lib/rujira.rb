# frozen_string_literal: true

require 'faraday'
require 'faraday/multipart'
require 'json'
require_relative 'rujira/error'
require_relative 'rujira/version'
require_relative 'rujira/configuration'
require_relative 'rujira/request'
require_relative 'rujira/api/common'
require_relative 'rujira/api/search'
require_relative 'rujira/api/issue'
require_relative 'rujira/api/project'
require_relative 'rujira/api/comment'
require_relative 'rujira/api/attachments'
require_relative 'rujira/api/myself'
require_relative 'rujira/api/server_info'

module Rujira
  class Error < StandardError; end

  def self.env_var?(var)
    %w[true 1 yes].include?(ENV[var]&.downcase)
  end
end

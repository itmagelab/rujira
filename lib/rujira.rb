# frozen_string_literal: true

require 'faraday'
require 'json'
require_relative 'rujira/version'
require_relative 'rujira/connection'
require_relative 'rujira/configuration'
require_relative 'rujira/entity'
require_relative 'rujira/api/item'
require_relative 'rujira/api/search'
require_relative 'rujira/api/issue'
require_relative 'rujira/api/project'
require_relative 'rujira/api/comment'
require_relative 'rujira/api/myself'
require_relative 'rujira/api/server_info'

module Rujira
  class Error < StandardError; end
end

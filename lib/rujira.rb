# frozen_string_literal: true

# https://tomdebruijn.com/posts/ruby-write-your-own-domain-specific-language/
# https://docs.atlassian.com/software/jira/docs/api/REST/8.17.1/

require 'faraday'
require 'json'
require_relative 'rujira/version'
require_relative 'rujira/connection'
require_relative 'rujira/configuration'
require_relative 'rujira/entity'
require_relative 'rujira/api/issue'
require_relative 'rujira/api/project'

module Rujira
  class Error < StandardError; end
end

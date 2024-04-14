# frozen_string_literal: true

module Rujira
  # TODO
  module Configuration
    def self.token
      return ENV['RUJIRA_TOKEN'] if ENV.include?('RUJIRA_TOKEN')

      raise 'The environment variable RUJIRA_TOKEN is not set'
    end

    def self.url
      return ENV['RUJIRA_URL'] if ENV.include?('RUJIRA_URL')

      'http://localhost:8080'
    end

    def self.debug
      return false unless ENV.include?('RUJIRA_DEBUG')

      ENV['RUJIRA_DEBUG'].match?(/^true$/)
    end
  end
end

# frozen_string_literal: true

module Rujira
  # TODO
  class Connection
    def self.new
      url = Configuration.url
      Faraday.new(url: url) do |builder|
        builder.request :authorization, 'Bearer', -> { token }
        builder.request :json
        builder.response :json
        builder.response :raise_error
        builder.response :logger if Configuration.debug
      end
    end

    private

    def self.token
      Configuration.token
    end
  end
end

# frozen_string_literal: true

module Rujira
  # TODO
  class Connection
    def initialize
      @url = Configuration.url
      @token = Configuration.token
    end

    def run
      Faraday.new(url: @url) do |builder|
        builder.request :authorization, 'Bearer', -> { @token }
        builder.request :json
        builder.response :json
        builder.response :raise_error
        builder.response :logger if Configuration.debug
      end
    end
  end
end

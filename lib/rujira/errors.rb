# frozen_string_literal: true

module Rujira
  # Base error class for every error raised by the library.
  #
  # It inherits from RuntimeError to stay compatible with code that rescued
  # RuntimeError before the dedicated error classes were introduced.
  #
  # @example Rescuing any Rujira error
  #   begin
  #     client.Issue.get('TEST-1')
  #   rescue Rujira::Error => e
  #     warn e.message
  #   end
  #
  class Error < RuntimeError; end

  # Raised when Jira answers with a non successful HTTP status.
  #
  # @return [Integer] HTTP status code of the response.
  # @return [String, nil] Raw response body.
  # @return [Faraday::Response, nil] The whole Faraday response.
  #
  # @example Inspecting a failed request
  #   rescue Rujira::HTTPError => e
  #     puts e.status
  #     puts e.body
  #
  class HTTPError < Error
    attr_reader :status, :body, :response

    def initialize(message = nil, status: nil, body: nil, response: nil)
      @status = status
      @body = body
      @response = response
      super(message || "Request failed with status #{status}")
    end
  end

  # Raised when required arguments are missing or malformed.
  #
  # Before this class was introduced the library called `abort`, which raised
  # SystemExit and terminated the host process. Now the problem is reported
  # as a regular, rescuable exception.
  #
  # @example
  #   client.Issue.get('') # => raises Rujira::ValidationError
  #
  class ValidationError < Error; end
end

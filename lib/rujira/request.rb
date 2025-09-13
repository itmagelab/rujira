# frozen_string_literal: true

require 'fileutils'

module Rujira
  # Represents an HTTP request configuration for Jira API calls.
  # Used internally by Rujira::Client to build requests with headers, params, payloads, and authorization.
  #
  class Request
    # @return [Array, nil] Authorization information, e.g., Bearer token or basic auth credentials
    attr_reader :authorization
    # @return [Hash] Additional options for the request (currently unused)
    attr_reader :options

    # Initializes a new request object with default values.
    #
    def initialize
      @token = ENV['RUJIRA_TOKEN'] if ENV.include?('RUJIRA_TOKEN')
      @method = :get
      @params = {}
      @headers = {}
      @payload = nil
      @rest_base_path = 'rest/api/2'
      @authorization = nil
      @path = nil
    end

    # Evaluates a block in the context of the request for configuration.
    #
    # @yield [self] Block used to set path, headers, params, method, etc.
    # @return [Request] Returns self for chaining.
    #
    # @example Configure a request
    #   request.builder do
    #     path 'issue/TEST-123'
    #     method :get
    #     headers 'X-Custom-Header': 'value'
    #   end
    #
    def builder(&block)
      return self unless block_given?

      instance_eval(&block)
      self
    end
    alias build builder

    # Sets the base REST path for the request.
    #
    # @param [String] path The base path (e.g., 'rest/api/2' or 'rest/agile/1.0')
    # @return [void]
    #
    def rest_base(path)
      @rest_base_path = path
    end

    # Gets or sets query parameters for the request.
    #
    # @param [Hash, nil] params Optional parameters to set.
    # @return [Hash] The current parameters.
    #
    def params(params = nil)
      return @params if params.nil?

      @params = params
    end

    # Gets or sets HTTP headers for the request.
    #
    # @param [Hash, nil] headers Optional headers to set.
    # @return [Hash] The current headers.
    #
    def headers(headers = nil)
      return @headers if headers.nil?

      @headers = headers
    end

    # Gets or sets the HTTP method for the request.
    #
    # @param [Symbol, nil] method Optional HTTP method (:get, :post, etc.)
    # @return [Symbol] The current method.
    #
    def method(method = nil)
      return @method if method.nil?

      @method = method
    end

    # Sets Bearer token authorization.
    #
    # @param [String] token The token to use for authorization.
    # @return [void]
    #
    def bearer(token)
      @authorization = 'Bearer', -> { token }
    end

    # Sets basic authentication.
    #
    # @param [String] username The username.
    # @param [String] password The password.
    # @return [void]
    #
    def basic(username, password)
      @authorization = :basic, username, password
    end

    # Gets or sets the request path (appended to rest_base_path).
    #
    # @param [String, nil] path The relative path to set.
    # @return [String] The full path combining rest_base_path and the given path.
    #
    def path(path = nil)
      return @path if path.nil?

      @path = "#{@rest_base_path}/#{path}"
      @path
    end

    # Gets or sets the request payload (body for POST/PUT/PATCH requests).
    #
    # @param [Object, nil] payload The payload to set.
    # @return [Object] The current payload.
    #
    def payload(payload = nil)
      return @payload if payload.nil?

      @payload = payload
    end
  end
end

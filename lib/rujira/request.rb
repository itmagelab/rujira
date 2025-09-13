# frozen_string_literal: true

require 'fileutils'

module Rujira
  # TODO
  class Request
    attr_reader :authorization, :options

    def initialize
      @token = Configuration.token
      @debug = Configuration.debug
      @method = :get
      @params = {}
      @headers = {}
      @payload = nil
      @rest_base_path = 'rest/api/2'
      @authorization = nil
      @path = nil
    end

    def builder(&block)
      return self unless block_given?

      instance_eval(&block)
      self
    end

    alias build builder

    def rest_base(path)
      @rest_base_path = path
    end

    def params(params = nil)
      return @params if params.nil?

      @params = params
    end

    def headers(headers = nil)
      return @headers if headers.nil?

      @headers = headers
    end

    def method(method = nil)
      return @method if method.nil?

      @method = method
    end

    def bearer(token)
      @authorization = 'Bearer', -> { token }
    end

    def basic(username, password)
      @authorization = :basic, username, password
    end

    def path(path = nil)
      return @path if path.nil?

      @path = "#{@rest_base_path}/#{path}"

      @path
    end

    def payload(payload = nil)
      return @payload if payload.nil?

      @payload = payload
    end
  end
end

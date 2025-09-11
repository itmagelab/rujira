# frozen_string_literal: true

require 'async/http/faraday'

module Rujira
  # TODO
  class Request # rubocop:disable Metrics/ClassLength
    def initialize # rubocop:disable Metrics/MethodLength
      @token = Configuration.token
      @debug = Configuration.debug
      @options = {
        url: Configuration.url
      }
      @method = :get
      @params = {}
      @headers = {}
      @payload = nil
      @base_uri = 'rest/api/2'
      @authorization = nil
      @path = nil
    end

    def builder(&block)
      return self unless block_given?

      instance_eval(&block)
      self
    end

    alias build builder

    def params(params)
      @params = params
    end

    def headers(headers)
      @headers = headers
    end

    def method(method)
      @method = method
    end

    def bearer(token)
      @authorization = 'Bearer', -> { token }
    end

    def basic(username, password)
      @authorization = :basic, username, password
    end

    def path(path)
      raise PathArgumentError if path.nil?

      @path = "#{@base_uri}/#{path}"

      @path if @path
    end

    def payload(payload)
      @payload = payload

      @payload if @payload
    end

    alias data payload

    def run
      rs = send(@method.downcase)
      cache rs if Rujira.env_var? 'RUJIRA_MAKE_MOCK'

      rs.body
    end

    alias commit run

    private

    def cache(res)
      path = res.to_hash[:url].path
      cache_path = File.join('.cache', path)
      if path.end_with?('/')
        cache_path = File.join(cache_path, 'index.json')
      else
        cache_path += '.json' unless File.extname(cache_path) != ''
      end
      FileUtils.mkdir_p(File.dirname(cache_path))
      File.write(cache_path, res.body)
    end

    def request
      yield
    rescue Faraday::Error => e
      raise "Status #{e.response[:status]}: #{e.response[:body]}"
    end

    def get
      request do
        client.get @path do |req|
          req.headers = @headers
          req.params = @params
          req.body = @payload
        end
      end
    end

    def delete
      request do
        client.delete @path do |req|
          req.headers = @headers
          req.params = @params
          req.body = @payload
        end
      end
    end

    def post
      request do
        client.post @path do |req|
          req.headers = @headers
          req.params = @params
          req.body = @payload
        end
      end
    end

    def put
      request do
        client.put @path do |req|
          req.headers = @headers
          req.params = @params
          req.body = @payload
        end
      end
    end

    def client
      Faraday.new(@options) do |builder|
        builder.adapter :async_http
        builder.request :authorization, *@authorization if @authorization
        builder.request :multipart, flat_encode: true
        builder.request :json
        builder.response :json
        builder.response :raise_error
        builder.response :logger if @debug
      end
    end
  end
end

# frozen_string_literal: true

module Rujira
  # TODO
  class Client
    attr_accessor :request

    def initialize(url, debug: false)
      @uri = URI(url)
      @debug = ENV.fetch('RUJIRA_DEBUG', debug.to_s) == 'true'
      @request = Request.new
      @options = @request.options.merge({
                                          url: @uri
                                        })
    end

    def method_missing(method_name, ...)
      resource_class = Rujira::Api.const_get(method_name.to_s)
      resource_class.new(self, ...)
    rescue NameError
      super
    end

    def respond_to_missing?(method_name, include_private = false)
      Rujira::Api.const_defined?(method_name.to_s) || super
    end

    def dispatch
      unless %i[get delete head post put patch].include?(@request.method)
        raise "method #{@request.method} not supported"
      end

      begin
        args = [@request.path]
        args << @request.payload if %i[post put patch].include?(@request.method)

        response = connection.public_send(@request.method, *args)
        cache response if @debug

        response.success? ? response.body : (raise "Request failed with status #{response.status}")
      rescue StandardError => e
        raise "Error: #{e.class} - #{e.message}"
      end
    end

    def connection
      Faraday.new(@options) do |builder|
        builder.request :authorization, *@request.authorization if @request.authorization
        builder.request :multipart, flat_encode: true
        builder.request :json
        builder.response :json
        builder.response :raise_error
        builder.response :logger if @debug
      end
    end

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
  end
end

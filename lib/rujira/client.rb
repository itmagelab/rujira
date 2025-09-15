# frozen_string_literal: true

require 'logger'

module Rujira
  # Main Jira API client.
  # Provides access to Jira resources via method_missing delegation to API classes.
  #
  # Example:
  #   client = Rujira::Client.new("https://jira.example.com")
  #   client.issue.get("TEST-123")
  #
  class Client
    attr_reader :logger, :dispatchable

    # Initializes a new Jira client.
    #
    # @param [String] url Base URL of the Jira instance.
    # @param [Boolean] debug Whether to enable debug logging. Can also be set via ENV['RUJIRA_DEBUG'].
    #
    # @example Initialize client
    #   client = Rujira::Client.new("https://jira.example.com", debug: true)
    #
    def initialize(url, debug: false, dispatchable: true, log_level: 'error') # rubocop:disable Metrics/MethodLength
      @dispatchable = dispatchable
      @uri = URI(url)
      @debug = ENV.fetch('RUJIRA_DEBUG', debug.to_s) == 'true'
      @raise_error = false
      @logger ||= Logger.new($stdout)

      log_levels = {
        'debug' => Logger::DEBUG,
        'info' => Logger::INFO,
        'warn' => Logger::WARN,
        'error' => Logger::ERROR,
        'fatal' => Logger::FATAL
      }

      @logger.level = log_levels.fetch(
        ENV.fetch('LOG_LEVEL', log_level).downcase,
        Logger::ERROR
      )
    end

    # Dynamically instantiates the appropriate API resource class.
    #
    # @param [Symbol] method_name Name of the API resource (e.g., :issue, :project)
    # @param [...] args Arguments passed to the resource class constructor
    # @return [Object] An instance of the corresponding API resource class
    #
    # @example Access an API resource
    #   client.issue.get("TEST-123")
    #
    def method_missing(method_name)
      resource_class = Rujira::Api.const_get(method_name.to_s)
      resource_class.new(self)
    rescue NameError
      super
    end

    # Checks if a resource class exists for method_missing.
    #
    # @param [Symbol] method_name Method name to check
    # @param [Boolean] include_private Include private methods
    # @return [Boolean] true if the resource exists, false otherwise
    #
    def respond_to_missing?(method_name, include_private = false)
      Rujira::Api.const_defined?(method_name.to_s) || super
    end

    # Executes the configured request.
    #
    # @return [Object] The API response body if successful
    # @raise [RuntimeError] If the request fails or method is unsupported
    #
    def dispatch(request) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      raise "method #{request.method} not supported" unless %i[get delete head post put patch].include?(request.method)

      begin
        args = [request.path]
        args << request.payload if %i[post put patch].include?(request.method)

        options = {
          url: @uri,
          headers: request.headers,
          params: request.params
        }
        response = connection(options, request.authorization).public_send(request.method, *args)

        if response.success?
          response.body
        else
          (raise "Request failed with status #{response.status} " \
                 "and body #{response.body}")
        end
      rescue StandardError => e
        raise "Error: #{e.class} - #{e.message}"
      end
    end

    # Builds the Faraday connection for HTTP requests.
    #
    # @return [Faraday::Connection] Configured Faraday connection
    #
    def connection(options, authorization)
      Faraday.new(options) do |builder|
        builder.request :authorization, *authorization if authorization
        builder.request :multipart, flat_encode: true
        builder.request :json
        builder.response :json
        builder.response :raise_error if @raise_error
        builder.response :logger, @logger if @debug
      end
    end

    # Prepares a file for multipart upload.
    #
    # @param [String] path Path to the file
    # @return [Faraday::Multipart::FilePart] File ready for upload
    #
    def file(path)
      Faraday::Multipart::FilePart.new(path, 'multipart/form-data')
    end

    # Generates mock JSON files for API responses (useful for caching or testing).
    #
    # @param [Object] res API response object
    # @return [void]
    #
    def generate_mocks(res)
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

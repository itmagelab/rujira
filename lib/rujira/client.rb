# frozen_string_literal: true

require 'base64'
require 'fileutils'
require 'logger'
require 'uri'

module Rujira
  # Main Jira API client.
  # Provides access to Jira resources via method_missing delegation to API classes.
  #
  # Example:
  #   client = Rujira::Client.new("https://jira.example.com")
  #   client.Issue.get("TEST-123")
  #
  class Client
    attr_reader :wrap_responses, :logger, :lazy, :token

    SUPPORTED_METHODS = %i[get delete head post put patch].freeze

    LOG_LEVELS = {
      'debug' => Logger::DEBUG,
      'info' => Logger::INFO,
      'warn' => Logger::WARN,
      'error' => Logger::ERROR,
      'fatal' => Logger::FATAL
    }.freeze

    # Initializes a new Jira client.
    #
    # @param [String] url Base URL of the Jira instance.
    # @param [Boolean] debug Whether to enable debug logging. Can also be set via ENV['RUJIRA_DEBUG'].
    # @param [Boolean] wrap_responses Whether API responses are wrapped into resource objects.
    # @param [Boolean] lazy Whether API calls return the request object instead of a response.
    # @param [String] log_level Minimal log level, can also be set via ENV['LOG_LEVEL'].
    # @param [String, nil] token Bearer token, by default ENV['RUJIRA_TOKEN'] is used.
    # @param [Logger, nil] logger Custom logger, by default a logger writing to stdout is used.
    #
    # @example Initialize client
    #   client = Rujira::Client.new("https://jira.example.com", debug: true)
    #
    def initialize(url, debug: false, wrap_responses: false, lazy: false, log_level: 'error', token: nil, logger: nil) # rubocop:disable Metrics/MethodLength
      @wrap_responses = wrap_responses
      @lazy = lazy
      @uri = URI(url)
      @debug = ENV.fetch('RUJIRA_DEBUG', debug.to_s) == 'true'
      @raise_error = false
      @logger = logger || Logger.new($stdout)

      unless logger
        @logger.level = LOG_LEVELS.fetch(
          ENV.fetch('LOG_LEVEL', log_level).downcase,
          Logger::ERROR
        )
      end

      @token = token || ENV['RUJIRA_TOKEN']
      @adapter = adapter
    end

    def adapter # rubocop:disable Metrics/MethodLength
      case ENV.fetch('RUJIRA_ADAPTER', nil)
      when 'typhoeus'
        @logger.debug 'Using Typhoeus adapter'
        require 'faraday/typhoeus'
        :typhoeus
      when 'async'
        require 'async/http/faraday'
        :async_http
      else
        Faraday.default_adapter
      end
    end

    # Dynamically instantiates the appropriate API resource class.
    #
    # Both `client.Issue` and `client.issue` styles are supported.
    #
    # @param [Symbol] method_name Name of the API resource (e.g., :Issue, :Project)
    # @return [Object] An instance of the corresponding API resource class
    #
    # @example Access an API resource
    #   client.Issue.get("TEST-123")
    #
    def method_missing(method_name, *args, &block)
      resource_class = api_class_for(method_name)
      return super unless resource_class
      return super unless args.empty? && block.nil?

      resource_class.new(self)
    end

    # Checks if a resource class exists for method_missing.
    #
    # @param [Symbol] method_name Method name to check
    # @param [Boolean] include_private Include private methods
    # @return [Boolean] true if the resource exists, false otherwise
    #
    def respond_to_missing?(method_name, include_private = false)
      !api_class_for(method_name).nil? || super
    end

    # Executes the configured request.
    #
    # @return [Object] The API response body if successful
    # @raise [Rujira::HTTPError] If the request fails
    # @raise [Rujira::Error] If the request method is unsupported
    #
    def dispatch(request) # rubocop:disable Metrics/AbcSize
      raise Rujira::Error, "method #{request.method} not supported" unless SUPPORTED_METHODS.include?(request.method)

      begin
        args = [request.path]
        args << request.payload if %i[post put patch].include?(request.method)

        response = connection.public_send(request.method, *args) do |req|
          req.params.merge!(request.params) unless request.params.empty?
          req.headers.merge!(request.headers) unless request.headers.empty?
          header = authorization_header(request)
          req.headers['Authorization'] = header if header
        end

        return response.body if response.success?

        raise HTTPError.new(
          "Request failed with status #{response.status} and body #{response.body}",
          status: response.status,
          body: response.body,
          response: response
        )
      rescue StandardError => e
        @logger.error "Error: #{e.class} - #{e.message}"
        raise
      end
    end

    # Builds the Faraday connection for HTTP requests.
    #
    # The connection is created once and reused for every request, so
    # keep-alive connections are not dropped between calls.
    #
    # @return [Faraday::Connection] Configured Faraday connection
    #
    def connection
      @connection ||= Faraday.new(url: @uri) do |builder|
        builder.adapter @adapter
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

    private

    # Looks up an API class by its name, ignoring case and underscores.
    #
    # @param [Symbol, String] method_name Name of the API resource
    # @return [Class, nil] The API class or nil when nothing matches
    #
    def api_class_for(method_name)
      target = method_name.to_s.delete('_').downcase
      return nil if target.empty?

      const = Rujira::Api.constants(false).find { |name| name.to_s.delete('_').downcase == target }
      const && Rujira::Api.const_get(const)
    end

    # Builds the Authorization header for the request.
    #
    # Request level credentials win over the client level token.
    #
    # @param [Request] request The request being executed
    # @return [String, nil] Header value or nil when no credentials are used
    #
    def authorization_header(request)
      auth = request.authorization
      auth = [Request::BEARER, @token] if auth.nil? && @token
      return nil if auth.nil? || auth == false

      type, *credentials = auth
      case type
      when Request::BEARER
        "Bearer #{resolve_credential(credentials.first)}"
      when Request::BASIC
        username, password = credentials
        "Basic #{Base64.strict_encode64("#{resolve_credential(username)}:#{resolve_credential(password)}")}"
      end
    end

    # Resolves a credential that may be a callable.
    #
    # @param [Object] value Credential value or callable returning it
    # @return [Object] The resolved value
    #
    def resolve_credential(value)
      value.respond_to?(:call) ? value.call : value
    end
  end
end

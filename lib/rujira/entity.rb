# frozen_string_literal: true

module Rujira
  # TODO
  class Entity
    def initialize
      @method = :get
      @params = {}
      @headers = {}
      @rest_api = 'rest/api/2'
    end

    def self.build(&block)
      entity = new
      return entity unless block_given?

      entity.instance_eval(&block)

      entity
    end

    def params(params)
      @params = params
    end

    def headers(headers)
      @headers = headers
    end

    def method(method)
      @method = method
    end

    def path(path = nil)
      raise PathArgumentError if path.nil?

      @path = "#{@rest_api}/#{path}"

      return @path if @path
    end

    def data(data = nil)
      raise DataArgumentError if data.nil?

      @data = data

      return @data if @data
    end

    def commit
      send(@method.downcase).body
    end

    private

    def request
      yield
    rescue Faraday::Error => e
      raise "Status #{e.response[:status]}: #{e.response[:body]}"
    end

    def get
      request do
        client.get @path do |req|
          req.params = @params
        end
      end
    end

    def delete
      request do
        client.delete @path do |req|
          req.params = @params
        end
      end
    end

    def post
      request do
        client.post @path do |req|
          req.headers = @headers
          req.params = @params
          req.body = @data
        end
      end
    end

    def put
      request do
        client.put @path do |req|
          req.params = @params
          req.body = @data
        end
      end
    end

    def client
      Rujira::Connection.new.conn
    end
  end
end

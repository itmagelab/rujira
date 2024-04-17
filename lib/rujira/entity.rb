# frozen_string_literal: true

module Rujira
  # TODO
  class Entity
    def initialize
      @method = :GET
      @params = {}
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

    def method(method)
      @method = method
    end

    def path(path = nil)
      @path ||= "#{@rest_api}/#{path}"

      return @path if @path

      raise ArgumentError, "No argument to 'path' was given."
    end

    def data(data = nil)
      @data ||= data

      return @data if @data

      raise ArgumentError, "No argument to 'data' was given."
    end

    def commit
      case @method
      when :GET
        get.body
      when :PUT
        put.body
      when :POST
        post.body
      when :DELETE
        delete.body
      end
    end

    private

    def request
      yield
    rescue Faraday::Error => e
      raise "Status #{e.response[:status]}: #{e.response[:body]}"
    end

    def get
      request do
        client.get path
      end
    end

    def delete
      request do
        client.delete path
      end
    end

    def post
      request do
        client.post path do |req|
          req.params = @params
          req.body = data.to_json
        end
      end
    end

    def put
      request do
        client.put path do |req|
          req.body = data.to_json
        end
      end
    end

    def client
      conn = Rujira::Connection.new
      conn.run
    end
  end
end

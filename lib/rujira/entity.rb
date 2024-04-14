# frozen_string_literal: true

module Rujira
  # TODO
  class Entity
    def initialize
      @method = :GET
    end

    def self.build(&block)
      entity = new
      return entity unless block_given?

      entity.instance_eval(&block)

      entity
    end

    def method(method)
      @method = method
    end

    def path(path = nil)
      @path ||= path

      return @path if @path

      raise ArgumentError, "No argument to 'path' was given."
    end

    def data(data = nil)
      @data ||= data

      return @data if @data

      raise ArgumentError, "No argument to 'data' was given."
    end

    def get
      client.get path
    end

    def post
      client.post path do |req|
        req.body = data.to_json
      end
    end

    def commit
      case @method
      when :GET
        get.body
      when :POST
        post.body
      end
    end

    private

    def client
      Rujira::Connection.new
    end
  end
end

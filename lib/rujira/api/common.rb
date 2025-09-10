# frozen_string_literal: true

module Rujira
  module Api
    # TODO
    class Common
      attr_reader :data

      def initialize(data = nil)
        @data = data
      end

      def self.rq
        Request.new.builder do
          bearer Configuration.token
        end
      end

      def self.method_missing(method, *_args)
        method = [method.to_sym]
        raise "The method #{method} does not exist.
               The following methods are available: #{methods(false)}"
      end

      def self.respond_to_missing?(method, include_private = false)
        methods.include?(method) || super
      end
    end
  end
end

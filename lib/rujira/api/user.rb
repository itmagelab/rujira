# frozen_string_literal: true

module Rujira
  module Api
    class User < Common # rubocop:disable Style/Documentation
      def create(&block)
        builder do
          path 'user'
          method :post
          instance_eval(&block) if block_given?
        end
        call
      end

      def update(key, &block)
        builder do
          path 'user'
          method :put
          params key: key
          instance_eval(&block) if block_given?
        end
        call
      end

      def get(key = nil, include_deleted: false, &block)
        builder do
          path 'user'
          method :get
          params key: key, includeDeleted: include_deleted
          instance_eval(&block) if block_given?
        end
        call
      end

      def delete(key, &block)
        builder do
          path 'user'
          method :delete
          params key: key
          instance_eval(&block) if block_given?
        end
        call
      end
    end
  end
end

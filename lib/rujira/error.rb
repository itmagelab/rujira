# frozen_string_literal: true

module Rujira
  class Error < StandardError; end

  # TODO
  class PathArgumentError < Error
    def message
      "No argument to 'path' was given."
    end
  end

  # TODO
  class DataArgumentError < Error
    def message
      "No argument to 'data' was given."
    end
  end
end

# frozen_string_literal: true

module Rujira
  class Error < StandardError; end

  # TODO: add docs
  # Some description
  class PathArgumentError < Error
    def message
      "No argument to 'path' was given."
    end
  end

  # TODO: add docs
  # Some description
  class DataArgumentError < Error
    def message
      "No argument to 'data' was given."
    end
  end
end

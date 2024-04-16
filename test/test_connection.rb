# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/rujira'

class ConnectionTest < Test::Unit::TestCase
  def test_connection
    Rujira::Connection.new.run
  end

  def test_class
    assert_instance_of Faraday::Connection, test_connection
  end
end

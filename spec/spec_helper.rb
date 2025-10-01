require 'rspec'
require 'webmock/rspec'
require_relative '../lib/rujira'

RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed
end

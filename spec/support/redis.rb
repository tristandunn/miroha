# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    Redis::Objects.redis = MockRedis.new
  end
end

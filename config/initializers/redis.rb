# frozen_string_literal: true

Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new }

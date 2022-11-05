# frozen_string_literal: true

Healthcheck.configure do |config|
  config.error   = 503
  config.method  = :get
  config.route   = "/health"
  config.success = 200
  config.verbose = false

  config.add_check :cache,      -> { Redis::Objects.redis.info }
  config.add_check :database,   -> { ActiveRecord::Base.connection.execute("SELECT 1") }
  config.add_check :migrations, -> { ActiveRecord::Migration.check_pending! }
end

# frozen_string_literal: true

require "bullet"

RSpec.configure do |config|
  config.before(:suite) do
    Bullet.enable = true
    Bullet.raise  = true
  end

  config.around do |example|
    Bullet.start_request

    example.run

    Bullet.end_request
  end
end

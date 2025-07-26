# frozen_string_literal: true

if Rails.env.local?
  Rack::Timeout::Logger.disable
else
  Rack::Timeout::Logger.level = Logger::ERROR
end

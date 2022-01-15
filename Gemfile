# frozen_string_literal: true

ruby   "3.1.0"
source "https://rubygems.org"

gem "bcrypt",       "3.1.16"
gem "bootsnap",     "1.9.4", require: false
gem "hiredis",      "0.6.3"
gem "oj",           "3.13.11"
gem "pg",           "1.2.3"
gem "puma",         "5.5.2"
gem "rack-attack",  "6.5.0"
gem "rack-timeout", "0.6.0"
gem "rails",        "7.0.1"
gem "redis",        "4.5.1", require: %w(redis redis/connection/hiredis)
gem "sassc-rails",  "2.1.2"
gem "turbo-rails",  "1.0.0"
gem "webpacker",    "5.4.3"

group :development, :test do
  gem "bullet",       "7.0.1"
  gem "cacheflow",    "0.2.1"
  gem "dotenv-rails", "2.7.6"
  gem "rspec-rails",  "5.0.2"
end

group :development do
  gem "brakeman",            "5.2.0", require: false
  gem "listen",              "3.7.1"
  gem "rubocop",             "1.24.1", require: false
  gem "rubocop-performance", "1.13.1", require: false
  gem "rubocop-rails",       "2.13.2", require: false
  gem "rubocop-rspec",       "2.7.0",  require: false
  gem "web-console",         "4.2.0"
end

group :test do
  gem "capybara",                 "3.36.0"
  gem "climate_control",          "1.0.1"
  gem "database_cleaner",         "2.0.1"
  gem "factory_bot_rails",        "6.2.0"
  gem "faker",                    "2.19.0"
  gem "rails-controller-testing", "1.0.5"
  gem "selenium-webdriver",       "4.0.3"
  gem "shoulda-matchers",         "5.1.0"
  gem "simplecov-console",        "0.9.1", require: false
end

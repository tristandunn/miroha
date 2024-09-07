# frozen_string_literal: true

require "capybara"

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--disable-site-isolation-trials")
  options.add_argument("--headless=new")
  options.add_argument("--no-sandbox")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.server = :puma, { Silent: true }
Capybara.javascript_driver = :selenium_chrome_headless

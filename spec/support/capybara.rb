# frozen_string_literal: true

require "capybara"

Capybara.register_driver :selenium_chrome_headless do |application|
  Capybara::Selenium::Driver.new(
    application,
    browser: :chrome,
    options: Selenium::WebDriver::Chrome::Options.new(
      args: [
        "--disable-dev-shm-usage",
        "--disable-site-isolation-trials",
        "--headless=new",
        "--no-sandbox"
      ]
    )
  )
end

Capybara.server = :puma, { Silent: true }
Capybara.javascript_driver = :selenium_chrome_headless

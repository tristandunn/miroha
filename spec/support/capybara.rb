# frozen_string_literal: true

require "capybara"

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new.tap do |arguments|
    arguments.add_argument("--no-sandbox")
    arguments.add_argument("--headless=new")
    arguments.add_argument("--window-size=1280,1024")
    arguments.add_argument("--disable-site-isolation-trials")
  end

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.server = :puma, { Silent: true }
Capybara.javascript_driver = :selenium_chrome_headless

module Selenium
  module WebDriver
    module Error
      class UnknownError
        alias old_initialize initialize

        def initialize(message = nil)
          if message&.include?("Node with given id does not belong to the document")
            raise StaleElementReferenceError.new(message)
          end

          old_initialize(message)
        end
      end
    end
  end
end

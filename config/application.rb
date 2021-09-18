# frozen_string_literal: true

require_relative "boot"

require "rails"
require "action_cable/engine"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Miroha
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Add the library directory to the autoload paths.
    config.autoload_paths << Rails.root.join("lib")

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end

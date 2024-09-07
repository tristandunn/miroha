# frozen_string_literal: true

require "./lib/middleware/backdoor"
require "active_support/core_ext/integer/time"

Rails.application.configure do
  # While tests run files are not watched, reloading is not necessary.
  config.enable_reloading = false

  # Eager loading loads your entire application. When running a single test
  # locally, this is usually not necessary, and can slow down your test suite.
  # However, it's recommended that you enable it in continuous integration
  # systems to ensure eager loading is working properly before deploying your
  # code.
  config.eager_load = ENV["CI"].present?

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.action_controller.perform_caching = false
  config.cache_store                       = :memory_store
  config.consider_all_requests_local       = true

  # Render exception templates for rescuable exceptions and raise for
  # other exceptions.
  config.action_dispatch.show_exceptions = :rescuable

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raises error for missing translations.
  config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Raise error when a before_action's only/except options reference
  # missing actions.
  config.action_controller.raise_on_missing_callback_actions = true

  # Run jobs asynchronously so Turbo jobs are executed.
  config.active_job.queue_adapter = :async

  # Add the authentication backdoor middleware.
  config.middleware.use(Middleware::Backdoor)
end

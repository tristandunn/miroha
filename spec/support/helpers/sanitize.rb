# frozen_string_literal: true

RSpec.configure do |config|
  config.include ActionView::Helpers::SanitizeHelper, type: :feature
end

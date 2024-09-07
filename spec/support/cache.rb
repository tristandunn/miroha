# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    Rails.cache.clear
  end
end

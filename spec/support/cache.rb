# frozen_string_literal: true

RSpec.configure do |config|
  config.before(cache: true) do
    allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache::MemoryStore.new)
  end
end

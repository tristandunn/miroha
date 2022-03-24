# frozen_string_literal: true

module RSpec
  module Helpers
    module Matchers
      module Waiting
        def wait_for(expectation)
          expect(page).to expectation

          yield
        end
      end

      RSpec.configure do |config|
        config.include Waiting, type: :feature
      end
    end
  end
end

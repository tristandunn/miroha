# frozen_string_literal: true

module RSpec
  module Helpers
    module Matchers
      module Surroundings
        def have_surrounding_character(character)
          have_css("#surrounding-characters li", text: character.name)
        end
      end

      RSpec.configure do |config|
        config.include Surroundings, type: :feature
      end
    end
  end
end

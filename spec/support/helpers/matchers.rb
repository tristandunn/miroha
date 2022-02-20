# frozen_string_literal: true

module RSpec
  module Helpers
    module Matchers
      module Surroundings
        def have_look_message(room, count: 1)
          have_css("#messages .message-look", text: room.description, count: count)
        end

        def have_surrounding_character(character)
          have_css("#surrounding-characters li", text: character.name)
        end

        def have_surrounding_monster(monster)
          have_css("#surrounding-monsters li", text: monster.name)
        end
      end

      RSpec.configure do |config|
        config.include Surroundings, type: :feature
      end
    end
  end
end

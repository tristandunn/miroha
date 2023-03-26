# frozen_string_literal: true

module RSpec
  module Helpers
    module Matchers
      module Feature
        def have_look_message(description, count: 1)
          have_css("#messages .message-look", text: description, count: count)
        end

        def have_surrounding_character(character)
          have_css("#surrounding-characters li", text: character.name)
        end

        def have_surrounding_monster(monster)
          have_css("#surrounding-monsters li", text: monster.name)
        end
      end

      module View
        def have_message_row(selector, **options)
          have_css(
            %(tr[data-chat-target="message"] #{selector}),
            **options
          )
        end
      end

      RSpec.configure do |config|
        config.include Feature, type: :feature
        config.include View,    type: :view
      end
    end
  end
end

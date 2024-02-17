# frozen_string_literal: true

module EventHandlers
  module Monster
    class Aggression
      # Increase the hate of the character for the monster when they enter
      # the room.
      #
      # @param [Character] character The character attacking the monster.
      # @param [Monster] monster The monster being attacked.
      # @return [void]
      def self.on_enter(character:, monster:)
        EventHandlers::Monster::Hate.on_attacked(
          character: character,
          damage:    1,
          monster:   monster
        )
      end
    end
  end
end

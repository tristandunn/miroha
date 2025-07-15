# frozen_string_literal: true

module EventHandlers
  module Monster
    class Aggression
      # Add hate of the character for the monster when they enter the room, if
      # there's no existing hate.
      #
      # @param [Character] character The character entering the room.
      # @param [Monster] monster The monster being attacked.
      # @return [void]
      def self.on_enter(character:, monster:)
        EventHandlers::Monster::Hate.on_attacked(character: character, monster: monster, damage: 1)
      end
    end
  end
end

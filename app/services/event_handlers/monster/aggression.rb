# frozen_string_literal: true

module EventHandlers
  module Monster
    class Aggression
      # Add hate of the character for the monster when they've entered the room.
      #
      # @param [Character] character The character entering the room.
      # @param [Monster] monster The monster being aggressive.
      # @return [void]
      def self.on_character_entered(character:, monster:)
        EventHandlers::Monster::Hate.on_character_attacked(character: character, monster: monster, damage: 1)
      end
    end
  end
end

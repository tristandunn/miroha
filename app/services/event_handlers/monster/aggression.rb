# frozen_string_literal: true

module EventHandlers
  module Monster
    class Aggression < Hate
      # Add hate of the character for the monster when they enter the room, if
      # there's no existing hate.
      #
      # @param [Character] character The character attacking the monster.
      # @param [Monster] monster The monster being attacked.
      # @return [void]
      def self.on_enter(character:, monster:)
        hates = Redis::SortedSet.new(KEY % monster.id)

        if hates.score(character.id).nil?
          hates.incr(character.id)
        end

        hates.expire(TTL)
      end
    end
  end
end

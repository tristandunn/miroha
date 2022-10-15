# frozen_string_literal: true

module EventHandlers
  module Monster
    class Hate
      KEY = "monster:%s:hate"
      TTL = 5.minutes

      # Increase the hate of the character for the monster.
      #
      # @param [Character] character The character attacking the monster.
      # @param [Integer] damage The damage dealt to the monster.
      # @param [Monster] monster The monster being attacked.
      # @return [void]
      def self.on_attacked(character:, damage:, monster:)
        hates = Redis::SortedSet.new(KEY % monster.id)
        hates.incr(character.id, damage)
        hates.expire(TTL)
      end
    end
  end
end

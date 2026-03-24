# frozen_string_literal: true

module EventHandlers
  module Monster
    class Hate
      DEFAULT_DURATION = 5.minutes
      KEY              = "monster:%s:hate"

      # Increase the hate of the character for the monster when it's attacked.
      #
      # @param [Character] character The character attacking the monster.
      # @param [Integer] damage The damage dealt to the monster.
      # @param [Monster] monster The monster being attacked.
      # @return [void]
      def self.on_character_attacked(character:, damage:, monster:)
        hates = Cache::SortedSet.new(KEY % monster.id, expires_in: duration_for(monster))
        hates.increment(character.id, damage)
      end

      # Return the hate duration for a monster.
      #
      # @param [Monster] monster The monster to get the duration for.
      # @return [Integer] The hate duration, in seconds.
      def self.duration_for(monster)
        value = monster.metadata["hate_duration"]

        if value.is_a?(Numeric)
          value
        else
          DEFAULT_DURATION.to_i
        end
      end
      private_class_method :duration_for
    end
  end
end

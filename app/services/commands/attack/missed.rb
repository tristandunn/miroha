# frozen_string_literal: true

module Commands
  class Attack < Base
    class Missed < Result
      locals :target_name

      delegate :name, to: :target, prefix: :target, private: true

      # Initialize a missed attack result.
      #
      # @return [void]
      def initialize(character:, target:)
        @character = character
        @target    = target
      end

      # Broadcast the missed attack.
      #
      # @return [void]
      def call
        broadcast_missed
      end

      private

      attr_reader :character, :target

      # Broadcast the missed attack to the character's room.
      #
      # @return [void]
      def broadcast_missed
        broadcast_append_later_to(
          character.room_gid,
          target:  :messages,
          partial: "commands/attack/observer/missed",
          locals:  { character: character, target_name: target_name }
        )
      end
    end
  end
end

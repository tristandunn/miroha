# frozen_string_literal: true

module Commands
  class Attack < Base
    class Hit < Result
      locals :damage, :target_name

      delegate :name, to: :target, prefix: :target

      # Initialize a successful attack hit result.
      #
      # @return [void]
      def initialize(character:, damage:, target:)
        @character = character
        @damage    = damage
        @target    = target
      end

      # Trigger an attacked event on the target and broadcast a hit message.
      #
      # @return [void]
      def call
        damage_target
        trigger_target_attacked
        broadcast_hit
      end

      private

      attr_reader :character, :target

      # Broadcast the attack hit to the room.
      #
      # @return [void]
      def broadcast_hit
        broadcast_append_later_to(
          character.room_gid,
          target:  :messages,
          partial: "commands/attack/observer/hit",
          locals:  { character: character, target_name: target_name }
        )
      end

      # Apply damage and save.
      #
      # @return [void]
      def damage_target
        target.current_health -= damage
        target.save!
      end

      # Notify the target it's being attacked.
      #
      # @return [void]
      def trigger_target_attacked
        target.trigger(:attacked, character: character, damage: damage)
      end
    end
  end
end

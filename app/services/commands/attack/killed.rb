# frozen_string_literal: true

module Commands
  class Attack < Base
    class Killed < Result
      locals :damage, :room, :target_name

      delegate :room, to: :character
      delegate :id, :name, to: :target, prefix: true

      # Initialize an attack killed result.
      #
      # @param [Character] character The character killing the target.
      # @param [Integer] damage The damage dealt to the target.
      # @param [Monster] target The target being killed.
      # @return [void]
      def initialize(character:, damage:, target:)
        @character = character
        @damage    = damage
        @target    = target
      end

      # Broadcast a kill message, expire the spawn, reward experience, and
      # update the character's sidebar.
      #
      # @return [void]
      def call
        transfer_items_to_room
        broadcast_killed
        expire_spawn
        reward_experience_and_level
        broadcast_sidebar_character
      end

      private

      attr_reader :character, :target

      # Broadcast a sidebar character replacement to the character.
      #
      # @return [void]
      def broadcast_sidebar_character
        broadcast_replace_later_to(
          character,
          target:  :character,
          partial: "game/sidebar/character",
          locals:  { character: character }
        )
      end

      # Broadcast the kill to the room.
      #
      # @return [void]
      def broadcast_killed
        broadcast_render_later_to(
          character.room_gid,
          partial: "commands/attack/observer/killed",
          locals:  { character: character, room: room, target_name: target_name }
        )
      end

      # Expire the target's spawn.
      #
      # @return [void]
      def expire_spawn
        Spawns::Expire.call(target.spawn)
      end

      # Reward the character experience for killing the target, and level the
      # character up when needed.
      #
      # @return [void]
      def reward_experience_and_level
        character.experience += target.experience

        if character.experience.remaining <= 0
          character.level += 1
        end

        character.save!
      end

      # Transfer the target's items to the room.
      #
      # @return [void]
      def transfer_items_to_room
        target.items.update!(owner: character.room)
        target.items.reset
      end
    end
  end
end

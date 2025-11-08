# frozen_string_literal: true

module EventHandlers
  module Monster
    class Follow
      # Move the monster to follow the character that exited.
      #
      # @param [Character] character The character exiting the room.
      # @param [String] direction The direction the character is moving.
      # @param [Monster] monster The monster following the character.
      # @return [void]
      def self.on_character_exited(character:, direction:, monster:)
        old_room = monster.room

        monster.update(room: character.room)

        broadcast_exit(monster, old_room) if old_room.present?
        broadcast_enter(monster, character.room) if character.room.present?
      end

      # Broadcast the monster exiting from the old room.
      #
      # @param [Monster] monster The monster that exited.
      # @param [Room] room The room the monster exited from.
      # @return [void]
      def self.broadcast_exit(monster, room)
        Turbo::StreamsChannel.broadcast_remove_to(
          room,
          target: "surrounding_monster_#{monster.id}"
        )
      end

      # Broadcast the monster entering the new room.
      #
      # @param [Monster] monster The monster that entered.
      # @param [Room] room The room the monster entered.
      # @return [void]
      def self.broadcast_enter(monster, room)
        Turbo::StreamsChannel.broadcast_append_later_to(
          room,
          target:  "surrounding-monsters",
          partial: "game/surroundings/monster",
          locals:  { monster: monster }
        )
      end
    end
  end
end

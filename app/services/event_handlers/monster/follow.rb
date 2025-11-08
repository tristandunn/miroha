# frozen_string_literal: true

module EventHandlers
  module Monster
    class Follow
      OFFSETS = {
        "down"  => { z: -1 },
        "east"  => { x: 1 },
        "north" => { y: 1 },
        "south" => { y: -1 },
        "up"    => { z: 1 },
        "west"  => { x: -1 }
      }.freeze

      # Move the monster in the direction the character exited.
      #
      # @param [Character] character The character exiting the room.
      # @param [String] direction The direction the character is moving.
      # @param [Monster] monster The monster following the character.
      # @return [void]
      def self.on_character_exited(character:, direction:, monster:)
        return if monster.room.nil?

        offsets = OFFSETS[direction]
        return if offsets.nil?

        target_room = Room.find_by(
          x: monster.room.x + offsets.fetch(:x, 0),
          y: monster.room.y + offsets.fetch(:y, 0),
          z: monster.room.z + offsets.fetch(:z, 0)
        )

        monster.update(room: target_room) if target_room.present?
      end
    end
  end
end

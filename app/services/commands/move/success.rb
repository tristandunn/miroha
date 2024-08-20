# frozen_string_literal: true

module Commands
  class Move < Base
    class Success < Result
      locals :room_source, :room_target

      # Initialize a successful move result.
      #
      # @param [Character] character The character moving.
      # @param [String] direction The direction the character is moving.
      # @param [Room] room_source The room the character is moving from.
      # @param [Room] room_target The room the character is moving to.
      # @return [void]
      def initialize(character:, direction:, room_source:, room_target:)
        @character   = character
        @direction   = direction
        @room_source = room_source
        @room_target = room_target
      end

      # Broadcast the move to the target and the source and target rooms.
      #
      # @return [void]
      def call
        move_character
        broadcast_exit
        broadcast_enter
      end

      private

      attr_reader :character, :direction

      # Broadcast the entrance to the target room.
      #
      # @return [void]
      def broadcast_enter
        broadcast_render_later_to(
          room_target,
          partial: "commands/move/enter",
          locals:  { character: character, direction: direction }
        )
      end

      # Broadcast the exit to the source room.
      #
      # @return [void]
      def broadcast_exit
        broadcast_render_later_to(
          room_source,
          partial: "commands/move/exit",
          locals:  { character: character, direction: direction }
        )
      end

      # Move the character to the target room.
      #
      # @return [void]
      def move_character
        character.update(room: room_target)
      end
    end
  end
end

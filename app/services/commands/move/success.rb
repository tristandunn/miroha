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

      # Move the character and perform the exiting and entering.
      #
      # @return [void]
      def call
        move_character
        perform_exit
        perform_enter
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

      # Broadcast and trigger the enter event.
      #
      # @return [void]
      def perform_enter
        broadcast_enter
        trigger_enter
      end

      # Broadcast the exit event.
      #
      # @return [void]
      def perform_exit
        broadcast_exit
      end

      # Trigger events for the entering the target room.
      #
      # @return [void]
      def trigger_enter
        trigger_enter_monsters
      end

      # Trigger event events on monsters in the target room that have enter
      # event handlers.
      #
      # @return [void]
      def trigger_enter_monsters
        room_target.monsters.with_event_handlers(:enter).find_each do |monster|
          monster.trigger(:enter, character: character)
        end
      end
    end
  end
end

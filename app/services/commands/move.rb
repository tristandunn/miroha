# frozen_string_literal: true

module Commands
  class Move < Base
    OFFSETS = {
      down:  { z: -1 },
      east:  { x:  1 },
      north: { y:  1 },
      south: { y: -1 },
      up:    { z:  1 },
      west:  { x: -1 }
    }.freeze

    THROTTLE_LIMIT  = 1
    THROTTLE_PERIOD = 1

    # Move the character to the target room and broadcast the move, if valid.
    #
    # @return [void]
    def call
      if room_target
        move_character
        broadcast_exit
        broadcast_enter
      end
    end

    # Determine if the command is rendered immediately.
    #
    # @return [Boolean]
    def rendered?
      true
    end

    private

    # Broadcast the entrance to the target room.
    #
    # @return [void]
    def broadcast_enter
      Turbo::StreamsChannel.broadcast_render_later_to(
        room_target,
        partial: "commands/move/enter",
        locals:  {
          character: character,
          direction: direction,
          room:      room_target
        }
      )
    end

    # Broadcast the exit to the source room.
    #
    # @return [void]
    def broadcast_exit
      Turbo::StreamsChannel.broadcast_render_later_to(
        room_source,
        partial: "commands/move/exit",
        locals:  {
          character: character,
          direction: direction,
          room:      room_source
        }
      )
    end

    # Return the direction, if valid.
    #
    # @return [Symbol] If the direction name is valid.
    # @return [nil] If the direction name is not valid.
    def direction
      name = input_without_command.to_sym

      if OFFSETS.key?(name)
        name
      end
    end

    # Return the locals for the partial template.
    #
    # @return [Hash] The local variables.
    def locals
      {
        direction:   direction,
        room_source: room_source,
        room_target: room_target
      }
    end

    # Move the character to the target room.
    #
    # @return [void]
    def move_character
      character.update(room: room_target)
    end

    # Return the offsets for the provided direction.
    #
    # @return [Hash] If there are offsets defined for the direction.
    # @return [nil] If there are no offsets defined for the direction.
    def offsets
      @offsets ||= OFFSETS[direction]
    end

    # Return the source room.
    #
    # @return [Room]
    def room_source
      @room_source ||= character.room
    end

    # Attempt to find the target room based on direction offsets.
    #
    # @return [Room] If there is a room at the target coordinates.
    # @return [nil] If there is not a room at the target coordinates.
    def room_target
      if offsets.present?
        @room_target ||= Room.find_by(target_coordinates)
      end
    end

    # Return the target coordinates for the move.
    #
    # @return [Hash]
    def target_coordinates
      {
        x: room_source.x + offsets.fetch(:x, 0),
        y: room_source.y + offsets.fetch(:y, 0),
        z: room_source.z + offsets.fetch(:z, 0)
      }
    end
  end
end

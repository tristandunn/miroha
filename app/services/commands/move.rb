# frozen_string_literal: true

module Commands
  class Move < Base
    OFFSETS = {
      "down"  => { z: -1 },
      "east"  => { x: 1 },
      "north" => { y: 1 },
      "south" => { y: -1 },
      "up"    => { z: 1 },
      "west"  => { x: -1 }
    }.freeze

    THROTTLE_LIMIT  = 1
    THROTTLE_PERIOD = 1

    argument direction: 0

    private

    # Return if the direction is invalid.
    #
    # @return [Boolean]
    def invalid_direction?
      !OFFSETS.key?(parameters[:direction])
    end

    # Return the offsets for the provided direction.
    #
    # @return [Hash]
    def offsets
      OFFSETS[parameters[:direction]]
    end

    # Return the source room.
    #
    # @return [Room]
    def room_source
      @room_source ||= character.room
    end

    # Return the target room based on the target coordinates.
    #
    # @return [Room] If the room is found.
    # @return [nil] If the room is not found.
    def room_target
      return @room_target if defined?(@room_target)

      @room_target = Room.find_by(target_coordinates)
    end

    # Return the handler for a successful command execution.
    #
    # @return [Success]
    def success
      Success.new(
        character:   character,
        direction:   parameters[:direction],
        room_source: room_source,
        room_target: room_target
      )
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

    # Validate the direction is valid.
    #
    # @return [InvalidDirection] If the direction is invalid.
    # @return [EmptyDirection] If there's no room in that direction.
    # @return [nil] If the direction is valid.
    def validate_direction
      if invalid_direction?
        InvalidDirection.new
      elsif room_target.nil?
        EmptyDirection.new(direction: parameters[:direction])
      end
    end
  end
end

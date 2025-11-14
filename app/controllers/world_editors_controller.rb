# frozen_string_literal: true

class WorldEditorsController < ApplicationController
  OFFSETS = {
    "north" => { y: 1 },
    "south" => { y: -1 },
    "east"  => { x: 1 },
    "west"  => { x: -1 },
    "up"    => { z: 1 },
    "down"  => { z: -1 }
  }.freeze

  # Render the world editor interface.
  #
  # @return [void]
  def show
    x = params[:x]&.to_i || Room::DEFAULT_COORDINATES[:x]
    y = params[:y]&.to_i || Room::DEFAULT_COORDINATES[:y]
    z = params[:z]&.to_i || Room::DEFAULT_COORDINATES[:z]

    @current_room = Room.find_or_initialize_by(x: x, y: y, z: z)
    @surrounding_rooms = load_surrounding_rooms(@current_room)
  end

  private

  # Load rooms in all 6 directions from the current room.
  #
  # @param room [Room] The current room
  # @return [Hash] Hash of direction => room (or nil if room doesn't exist)
  def load_surrounding_rooms(room)
    OFFSETS.transform_keys(&:to_sym).transform_values do |offsets|
      Room.find_by(target_coordinates(room, offsets))
    end
  end

  # Return target coordinates for a room with offsets applied.
  #
  # @param room [Room]
  # @param offsets [Hash]
  # @return [Hash]
  def target_coordinates(room, offsets)
    {
      x: room.x + offsets.fetch(:x, 0),
      y: room.y + offsets.fetch(:y, 0),
      z: room.z + offsets.fetch(:z, 0)
    }
  end
end

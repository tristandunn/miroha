# frozen_string_literal: true

class WorldEditorsController < ApplicationController
  ROOM_OFFSETS = {
    north: [0, 1, 0],
    south: [0, -1, 0],
    east:  [1, 0, 0],
    west:  [-1, 0, 0],
    up:    [0, 0, 1],
    down:  [0, 0, -1]
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
    ROOM_OFFSETS.transform_values do |(x_offset, y_offset, z_offset)|
      find_room_at(room.x + x_offset, room.y + y_offset, room.z + z_offset)
    end
  end

  # Find a room at specific coordinates.
  #
  # @param x_coord [Integer]
  # @param y_coord [Integer]
  # @param z_coord [Integer]
  # @return [Room, nil]
  def find_room_at(x_coord, y_coord, z_coord)
    Room.find_by(x: x_coord, y: y_coord, z: z_coord)
  end
end

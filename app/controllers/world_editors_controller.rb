# frozen_string_literal: true

class WorldEditorsController < ApplicationController
  before_action :authenticate

  # Render the world editor interface.
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
    {
      north: Room.find_by(x: room.x, y: room.y + 1, z: room.z),
      south: Room.find_by(x: room.x, y: room.y - 1, z: room.z),
      east: Room.find_by(x: room.x + 1, y: room.y, z: room.z),
      west: Room.find_by(x: room.x - 1, y: room.y, z: room.z),
      up: Room.find_by(x: room.x, y: room.y, z: room.z + 1),
      down: Room.find_by(x: room.x, y: room.y, z: room.z - 1)
    }
  end
end

# frozen_string_literal: true

module Api
  class RoomsController < ApplicationController
    before_action :set_room, only: %i(show update)

    # GET /api/rooms/:id
    def show
      render json: room_json(@room)
    end

    # POST /api/rooms
    def create
      @room = Room.new(room_params)

      if @room.save
        render json: room_json(@room), status: :created
      else
        render json: { errors: @room.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/rooms/:id
    def update
      if @room.update(room_params)
        render json: room_json(@room)
      else
        render json: { errors: @room.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_room
      @room = Room.find(params[:id])
    end

    def room_params
      params.require(:room).permit(:x, :y, :z, :description, objects: {})
    end

    def room_json(room)
      {
        id: room.id,
        x: room.x,
        y: room.y,
        z: room.z,
        description: room.description,
        objects: room.objects,
        items: room.items.map { |item| { id: item.id, name: item.name } },
        npcs: room.npcs.map { |npc| { id: npc.id, name: npc.name } },
        monsters: room.monsters.map { |monster| { id: monster.id, name: monster.name, current_health: monster.current_health, maximum_health: monster.maximum_health } },
        spawns: room.spawns.includes(:base).map do |spawn|
          {
            id: spawn.id,
            base_type: spawn.base_type,
            base_id: spawn.base_id,
            base_name: spawn.base.name,
            entity_id: spawn.entity_id,
            frequency: spawn.frequency,
            duration: spawn.duration,
            activates_at: spawn.activates_at,
            expires_at: spawn.expires_at
          }
        end
      }
    end
  end
end

# frozen_string_literal: true

module World
  class RoomsController < ApplicationController
    before_action :set_room, only: %i(show update)

    # Return room data with associated entities.
    #
    # @return [void]
    def show
      render json: room_json(@room)
    end

    # Create a new room.
    #
    # @return [void]
    def create
      @room = Room.new(room_params)

      if @room.save
        render json: room_json(@room), status: :created
      else
        render json: { errors: @room.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # Update an existing room.
    #
    # @return [void]
    def update
      if @room.update(room_params)
        render json: room_json(@room)
      else
        render json: { errors: @room.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    # Set the room from the ID parameter.
    #
    # @return [void]
    def set_room
      @room = Room.find(params[:id])
    end

    # Return permitted parameters for room.
    #
    # @return [ActionController::Parameters]
    def room_params
      params.expect(room: [:x, :y, :z, :description, { objects: {} }])
    end

    # Return room as JSON hash with associated entities.
    #
    # @param room [Room]
    # @return [Hash]
    def room_json(room)
      room_base_json(room).merge(room_entities_json(room))
    end

    # Return room base attributes as JSON hash.
    #
    # @param room [Room]
    # @return [Hash]
    def room_base_json(room)
      {
        id:          room.id,
        x:           room.x,
        y:           room.y,
        z:           room.z,
        description: room.description,
        objects:     room.objects
      }
    end

    # Return room entities as JSON hash.
    #
    # @param room [Room]
    # @return [Hash]
    def room_entities_json(room)
      {
        items:    room.items.map { |item| { id: item.id, name: item.name } },
        npcs:     room.npcs.map { |npc| { id: npc.id, name: npc.name } },
        monsters: room_monsters_json(room),
        spawns:   room_spawns_json(room)
      }
    end

    # Return monsters as JSON array.
    #
    # @param room [Room]
    # @return [Array<Hash>]
    def room_monsters_json(room)
      room.monsters.map do |monster|
        {
          id:             monster.id,
          name:           monster.name,
          current_health: monster.current_health,
          maximum_health: monster.maximum_health
        }
      end
    end

    # Return spawns as JSON array.
    #
    # @param room [Room]
    # @return [Array<Hash>]
    def room_spawns_json(room)
      room.spawns.includes(:base).map { |spawn| spawn_hash(spawn) }
    end

    # Return spawn as JSON hash.
    #
    # @param spawn [Spawn]
    # @return [Hash]
    def spawn_hash(spawn)
      {
        id:           spawn.id,
        base_type:    spawn.base_type,
        base_id:      spawn.base_id,
        base_name:    spawn.base.name,
        entity_id:    spawn.entity_id,
        frequency:    spawn.frequency,
        duration:     spawn.duration,
        activates_at: spawn.activates_at,
        expires_at:   spawn.expires_at
      }
    end
  end
end

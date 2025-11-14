# frozen_string_literal: true

module Api
  class SpawnsController < ApplicationController
    before_action :authenticate
    before_action :set_spawn, only: %i(update destroy)

    # POST /api/spawns
    def create
      @spawn = Spawn.new(spawn_params)

      if @spawn.save
        render json: spawn_json(@spawn), status: :created
      else
        render json: { errors: @spawn.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/spawns/:id
    def update
      if @spawn.update(spawn_params)
        render json: spawn_json(@spawn)
      else
        render json: { errors: @spawn.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/spawns/:id
    def destroy
      @spawn.destroy
      head :no_content
    end

    private

    def set_spawn
      @spawn = Spawn.find(params[:id])
    end

    def spawn_params
      params.require(:spawn).permit(:base_id, :base_type, :room_id, :frequency, :duration)
    end

    def spawn_json(spawn)
      {
        id: spawn.id,
        base_id: spawn.base_id,
        base_type: spawn.base_type,
        base_name: spawn.base.name,
        entity_id: spawn.entity_id,
        room_id: spawn.room_id,
        frequency: spawn.frequency,
        duration: spawn.duration,
        activates_at: spawn.activates_at,
        expires_at: spawn.expires_at
      }
    end
  end
end

# frozen_string_literal: true

module Api
  class SpawnsController < ApplicationController
    before_action :set_spawn, only: %i(update destroy)

    # Create a new spawn.
    #
    # @return [void]
    def create
      @spawn = Spawn.new(spawn_params)

      if @spawn.save
        render json: spawn_json(@spawn), status: :created
      else
        render json: { errors: @spawn.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # Update an existing spawn.
    #
    # @return [void]
    def update
      if @spawn.update(spawn_params)
        render json: spawn_json(@spawn)
      else
        render json: { errors: @spawn.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # Destroy a spawn.
    #
    # @return [void]
    def destroy
      @spawn.destroy
      head :no_content
    end

    private

    # Set the spawn from the ID parameter.
    #
    # @return [void]
    def set_spawn
      @spawn = Spawn.find(params[:id])
    end

    # Return permitted parameters for spawn.
    #
    # @return [ActionController::Parameters]
    def spawn_params
      params.expect(spawn: %i(base_id base_type room_id frequency duration))
    end

    # Return spawn as JSON hash.
    #
    # @param spawn [Spawn]
    # @return [Hash]
    def spawn_json(spawn)
      spawn_base_json(spawn).merge(spawn_timing_json(spawn))
    end

    # Return spawn base information as JSON hash.
    #
    # @param spawn [Spawn]
    # @return [Hash]
    def spawn_base_json(spawn)
      {
        id:        spawn.id,
        base_id:   spawn.base_id,
        base_type: spawn.base_type,
        base_name: spawn.base.name,
        entity_id: spawn.entity_id,
        room_id:   spawn.room_id
      }
    end

    # Return spawn timing information as JSON hash.
    #
    # @param spawn [Spawn]
    # @return [Hash]
    def spawn_timing_json(spawn)
      {
        frequency:    spawn.frequency,
        duration:     spawn.duration,
        activates_at: spawn.activates_at,
        expires_at:   spawn.expires_at
      }
    end
  end
end

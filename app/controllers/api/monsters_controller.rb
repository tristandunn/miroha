# frozen_string_literal: true

module Api
  class MonstersController < ApplicationController
    before_action :set_monster, only: %i(update destroy)

    # Create a new monster.
    #
    # @return [void]
    def create
      @monster = Monster.new(monster_params)

      if @monster.save
        render json: monster_json(@monster), status: :created
      else
        render json: { errors: @monster.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # Update an existing monster.
    #
    # @return [void]
    def update
      if @monster.update(monster_params)
        render json: monster_json(@monster)
      else
        render json: { errors: @monster.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # Destroy a monster.
    #
    # @return [void]
    def destroy
      @monster.destroy
      head :no_content
    end

    private

    # Set the monster from the ID parameter.
    #
    # @return [void]
    def set_monster
      @monster = Monster.find(params[:id])
    end

    # Return permitted parameters for monster.
    #
    # @return [ActionController::Parameters]
    def monster_params
      params.expect(monster: [:name, :current_health, :maximum_health, :experience, :room_id,
                              { event_handlers: [] }])
    end

    # Return monster as JSON hash.
    #
    # @param monster [Monster]
    # @return [Hash]
    def monster_json(monster)
      {
        id:             monster.id,
        name:           monster.name,
        current_health: monster.current_health,
        maximum_health: monster.maximum_health,
        experience:     monster.experience,
        event_handlers: monster.event_handlers,
        room_id:        monster.room_id
      }
    end
  end
end

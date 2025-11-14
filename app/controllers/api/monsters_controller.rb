# frozen_string_literal: true

module Api
  class MonstersController < ApplicationController
    before_action :require_authentication
    before_action :set_monster, only: %i(update destroy)

    # POST /api/monsters
    def create
      @monster = Monster.new(monster_params)

      if @monster.save
        render json: monster_json(@monster), status: :created
      else
        render json: { errors: @monster.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/monsters/:id
    def update
      if @monster.update(monster_params)
        render json: monster_json(@monster)
      else
        render json: { errors: @monster.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/monsters/:id
    def destroy
      @monster.destroy
      head :no_content
    end

    private

    def set_monster
      @monster = Monster.find(params[:id])
    end

    def monster_params
      params.require(:monster).permit(:name, :current_health, :maximum_health, :experience, :room_id, event_handlers: [])
    end

    def monster_json(monster)
      {
        id: monster.id,
        name: monster.name,
        current_health: monster.current_health,
        maximum_health: monster.maximum_health,
        experience: monster.experience,
        event_handlers: monster.event_handlers,
        room_id: monster.room_id
      }
    end
  end
end

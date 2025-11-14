# frozen_string_literal: true

module Api
  class NpcsController < ApplicationController
    before_action :require_authentication
    before_action :set_npc, only: %i(update destroy)

    # POST /api/npcs
    def create
      @npc = Npc.new(npc_params)

      if @npc.save
        render json: npc_json(@npc), status: :created
      else
        render json: { errors: @npc.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/npcs/:id
    def update
      if @npc.update(npc_params)
        render json: npc_json(@npc)
      else
        render json: { errors: @npc.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/npcs/:id
    def destroy
      @npc.destroy
      head :no_content
    end

    private

    def set_npc
      @npc = Npc.find(params[:id])
    end

    def npc_params
      params.require(:npc).permit(:name, :room_id)
    end

    def npc_json(npc)
      {
        id: npc.id,
        name: npc.name,
        room_id: npc.room_id
      }
    end
  end
end

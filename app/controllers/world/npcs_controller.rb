# frozen_string_literal: true

module World
  class NpcsController < ApplicationController
    before_action :set_npc, only: %i(update destroy)

    # Create a new NPC.
    #
    # @return [void]
    def create
      @npc = Npc.new(npc_params)

      if @npc.save
        render json: npc_json(@npc), status: :created
      else
        render json: { errors: @npc.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # Update an existing NPC.
    #
    # @return [void]
    def update
      if @npc.update(npc_params)
        render json: npc_json(@npc)
      else
        render json: { errors: @npc.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # Destroy an NPC.
    #
    # @return [void]
    def destroy
      @npc.destroy
      head :no_content
    end

    private

    # Set the NPC from the ID parameter.
    #
    # @return [void]
    def set_npc
      @npc = Npc.find(params[:id])
    end

    # Return permitted parameters for NPC.
    #
    # @return [ActionController::Parameters]
    def npc_params
      params.expect(npc: %i(name room_id))
    end

    # Return NPC as JSON hash.
    #
    # @param npc [Npc]
    # @return [Hash]
    def npc_json(npc)
      {
        id:      npc.id,
        name:    npc.name,
        room_id: npc.room_id
      }
    end
  end
end

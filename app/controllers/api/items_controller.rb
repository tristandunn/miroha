# frozen_string_literal: true

module Api
  class ItemsController < ApplicationController
    before_action :require_authentication
    before_action :set_item, only: %i(update destroy)

    # POST /api/items
    def create
      @item = Item.new(item_params)

      if @item.save
        render json: item_json(@item), status: :created
      else
        render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/items/:id
    def update
      if @item.update(item_params)
        render json: item_json(@item)
      else
        render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/items/:id
    def destroy
      @item.destroy
      head :no_content
    end

    private

    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:name, :owner_id, :owner_type)
    end

    def item_json(item)
      {
        id: item.id,
        name: item.name,
        owner_id: item.owner_id,
        owner_type: item.owner_type
      }
    end
  end
end

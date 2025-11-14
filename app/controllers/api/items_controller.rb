# frozen_string_literal: true

module Api
  class ItemsController < ApplicationController
    before_action :set_item, only: %i(update destroy)

    # Create a new item.
    #
    # @return [void]
    def create
      @item = Item.new(item_params)

      if @item.save
        render json: item_json(@item), status: :created
      else
        render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # Update an existing item.
    #
    # @return [void]
    def update
      if @item.update(item_params)
        render json: item_json(@item)
      else
        render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # Destroy an item.
    #
    # @return [void]
    def destroy
      @item.destroy
      head :no_content
    end

    private

    # Set the item from the ID parameter.
    #
    # @return [void]
    def set_item
      @item = Item.find(params[:id])
    end

    # Return permitted parameters for item.
    #
    # @return [ActionController::Parameters]
    def item_params
      params.expect(item: %i(name owner_id owner_type))
    end

    # Return item as JSON hash.
    #
    # @param item [Item]
    # @return [Hash]
    def item_json(item)
      {
        id:         item.id,
        name:       item.name,
        owner_id:   item.owner_id,
        owner_type: item.owner_type
      }
    end
  end
end

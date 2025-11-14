# frozen_string_literal: true

require "rails_helper"

describe World::ItemsController do
  let!(:room) { create(:room) }

  describe "#create" do
    context "with valid attributes" do
      let(:item_params) do
        {
          name:       "Magic Sword",
          owner_id:   room.id,
          owner_type: "Room"
        }
      end

      it "creates a new item" do
        expect do
          post :create, params: { item: item_params }, format: :json
        end.to change(Item, :count).by(1)
      end

      it "returns the created item" do
        post :create, params: { item: item_params }, format: :json

        expect(response).to have_http_status(:created)
        json = response.parsed_body
        expect(json["name"]).to eq("Magic Sword")
        expect(json["owner_id"]).to eq(room.id)
        expect(json["owner_type"]).to eq("Room")
      end
    end

    context "with invalid attributes" do
      let(:invalid_params) { { name: "" } }

      it "does not create a new item" do
        expect do
          post :create, params: { item: invalid_params }, format: :json
        end.not_to change(Item, :count)
      end

      it "returns errors" do
        post :create, params: { item: invalid_params }, format: :json

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "#update" do
    let!(:item) { create(:item, name: "Old Item", owner: room) }

    context "with valid attributes" do
      it "updates the item" do
        patch :update, params: { id: item.id, item: { name: "Updated Item" } }, format: :json

        item.reload
        expect(item.name).to eq("Updated Item")
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid attributes" do
      it "returns errors" do
        patch :update, params: { id: item.id, item: { name: "" } }, format: :json

        expect(response).to have_http_status(:unprocessable_content)
        json = response.parsed_body
        expect(json["errors"]).to be_present
      end
    end
  end

  describe "#destroy" do
    let!(:item) { create(:item, owner: room) }

    it "destroys the item" do
      expect do
        delete :destroy, params: { id: item.id }, format: :json
      end.to change(Item, :count).by(-1)
    end

    it "returns no content" do
      delete :destroy, params: { id: item.id }, format: :json

      expect(response).to have_http_status(:no_content)
    end
  end
end

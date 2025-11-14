# frozen_string_literal: true

require "rails_helper"

describe World::NpcsController do
  let!(:room) { create(:room) }

  describe "#create" do
    context "with valid attributes" do
      let(:npc_params) { { name: "Friendly Merchant", room_id: room.id } }

      it "creates a new NPC" do
        expect do
          post :create, params: { npc: npc_params }, format: :json
        end.to change(Npc, :count).by(1)
      end

      it "returns the created NPC" do
        post :create, params: { npc: npc_params }, format: :json

        aggregate_failures do
          expect(response).to have_http_status(:created)
          json = response.parsed_body
          expect(json["name"]).to eq("Friendly Merchant")
          expect(json["room_id"]).to eq(room.id)
        end
      end
    end

    context "with invalid attributes" do
      let(:invalid_params) { { name: "" } }

      it "does not create a new NPC" do
        expect do
          post :create, params: { npc: invalid_params }, format: :json
        end.not_to change(Npc, :count)
      end

      it "returns errors" do
        post :create, params: { npc: invalid_params }, format: :json

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "#update" do
    let!(:npc) { create(:npc, name: "Old Name", room: room) }

    context "with valid attributes" do
      it "updates the NPC" do
        patch :update, params: { id: npc.id, npc: { name: "New Name" } }, format: :json

        aggregate_failures do
          npc.reload
          expect(npc.name).to eq("New Name")
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "with invalid attributes" do
      it "returns errors" do
        patch :update, params: { id: npc.id, npc: { name: "" } }, format: :json

        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_content)
          json = response.parsed_body
          expect(json["errors"]).to be_present
        end
      end
    end
  end

  describe "#destroy" do
    let!(:npc) { create(:npc, room: room) }

    it "destroys the NPC" do
      expect do
        delete :destroy, params: { id: npc.id }, format: :json
      end.to change(Npc, :count).by(-1)
    end

    it "returns no content" do
      delete :destroy, params: { id: npc.id }, format: :json

      expect(response).to have_http_status(:no_content)
    end
  end
end

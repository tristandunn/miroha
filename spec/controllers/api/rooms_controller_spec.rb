# frozen_string_literal: true

require "rails_helper"

describe Api::RoomsController do
  before do
    sign_in
  end

  describe "#show" do
    let!(:room) { create(:room, x: 0, y: 0, z: 0, description: "Test room") }
    let!(:npc) { create(:npc, name: "Test NPC", room: room) }
    let!(:monster) { create(:monster, name: "Test Monster", room: room) }
    let!(:item) { create(:item, name: "Test Item", owner: room) }

    before do
      get :show, params: { id: room.id }, format: :json
    end

    it { is_expected.to respond_with(200) }

    it "returns room data with associations" do
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(room.id)
      expect(json["x"]).to eq(0)
      expect(json["y"]).to eq(0)
      expect(json["z"]).to eq(0)
      expect(json["description"]).to eq("Test room")
      expect(json["npcs"]).to be_an(Array)
      expect(json["npcs"].first["name"]).to eq("Test NPC")
      expect(json["monsters"]).to be_an(Array)
      expect(json["monsters"].first["name"]).to eq("Test Monster")
      expect(json["items"]).to be_an(Array)
      expect(json["items"].first["name"]).to eq("Test Item")
    end
  end

  describe "#create" do
    context "with valid attributes" do
      let(:room_params) do
        {
          x: 5,
          y: 10,
          z: -3,
          description: "A new room",
          objects: { "table" => "A wooden table" }
        }
      end

      it "creates a new room" do
        expect do
          post :create, params: { room: room_params }, format: :json
        end.to change(Room, :count).by(1)
      end

      it "returns the created room" do
        post :create, params: { room: room_params }, format: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["x"]).to eq(5)
        expect(json["y"]).to eq(10)
        expect(json["z"]).to eq(-3)
        expect(json["description"]).to eq("A new room")
        expect(json["objects"]["table"]).to eq("A wooden table")
      end
    end

    context "with invalid attributes" do
      let(:invalid_params) do
        { x: 0, y: 0, z: 0, description: "" }
      end

      it "does not create a new room" do
        expect do
          post :create, params: { room: invalid_params }, format: :json
        end.not_to change(Room, :count)
      end

      it "returns errors" do
        post :create, params: { room: invalid_params }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["errors"]).to be_present
      end
    end
  end

  describe "#update" do
    let!(:room) { create(:room, x: 0, y: 0, z: 0, description: "Old description") }

    context "with valid attributes" do
      let(:update_params) do
        {
          description: "Updated description",
          objects: { "painting" => "A beautiful painting" }
        }
      end

      it "updates the room" do
        patch :update, params: { id: room.id, room: update_params }, format: :json

        room.reload
        expect(room.description).to eq("Updated description")
        expect(room.objects["painting"]).to eq("A beautiful painting")
      end

      it "returns the updated room" do
        patch :update, params: { id: room.id, room: update_params }, format: :json

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["description"]).to eq("Updated description")
      end
    end

    context "with invalid attributes" do
      let(:invalid_params) { { description: "" } }

      it "does not update the room" do
        patch :update, params: { id: room.id, room: invalid_params }, format: :json

        room.reload
        expect(room.description).to eq("Old description")
      end

      it "returns errors" do
        patch :update, params: { id: room.id, room: invalid_params }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["errors"]).to be_present
      end
    end
  end
end

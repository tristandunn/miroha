# frozen_string_literal: true

require "rails_helper"

describe World::SpawnsController do
  let!(:room) { create(:room) }
  let!(:base_monster) { create(:monster, name: "Base Goblin", room: nil) }

  describe "#create" do
    context "with valid attributes" do
      let(:spawn_params) do
        {
          base_id:   base_monster.id,
          base_type: "Monster",
          room_id:   room.id,
          frequency: 300,
          duration:  600
        }
      end

      it "creates a new spawn" do
        expect do
          post :create, params: { spawn: spawn_params }, format: :json
        end.to change(Spawn, :count).by(1)
      end

      it "returns the created spawn" do
        post :create, params: { spawn: spawn_params }, format: :json

        aggregate_failures do
          expect(response).to have_http_status(:created)
          json = response.parsed_body
          expect(json["base_id"]).to eq(base_monster.id)
          expect(json["base_type"]).to eq("Monster")
          expect(json["base_name"]).to eq("Base Goblin")
          expect(json["room_id"]).to eq(room.id)
          expect(json["frequency"]).to eq(300)
          expect(json["duration"]).to eq(600)
        end
      end
    end

    context "with invalid attributes" do
      let(:invalid_params) { { base_type: "Monster" } }

      it "does not create a new spawn" do
        expect do
          post :create, params: { spawn: invalid_params }, format: :json
        end.not_to change(Spawn, :count)
      end

      it "returns errors" do
        post :create, params: { spawn: invalid_params }, format: :json

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "#update" do
    let!(:spawn) { create(:spawn, base: base_monster, room: room, frequency: 300) }

    context "with valid attributes" do
      it "updates the spawn" do
        patch :update, params: {
          id:    spawn.id,
          spawn: { frequency: 600, duration: 900 }
        }, format: :json

        aggregate_failures do
          spawn.reload
          expect(spawn.frequency).to eq(600)
          expect(spawn.duration).to eq(900)
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "with invalid attributes" do
      it "returns errors" do
        patch :update, params: { id: spawn.id, spawn: { frequency: -1 } }, format: :json

        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_content)
          json = response.parsed_body
          expect(json["errors"]).to be_present
        end
      end
    end
  end

  describe "#destroy" do
    let!(:spawn) { create(:spawn, base: base_monster, room: room) }

    it "destroys the spawn" do
      expect do
        delete :destroy, params: { id: spawn.id }, format: :json
      end.to change(Spawn, :count).by(-1)
    end

    it "returns no content" do
      delete :destroy, params: { id: spawn.id }, format: :json

      expect(response).to have_http_status(:no_content)
    end
  end
end

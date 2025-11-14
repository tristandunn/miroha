# frozen_string_literal: true

require "rails_helper"

describe World::MonstersController do
  let!(:room) { create(:room) }

  describe "#create" do
    context "with valid attributes" do
      let(:monster_params) do
        {
          name:           "Goblin",
          current_health: 50,
          maximum_health: 50,
          experience:     100,
          room_id:        room.id
        }
      end

      it "creates a new monster" do
        expect do
          post :create, params: { monster: monster_params }, format: :json
        end.to change(Monster, :count).by(1)
      end

      it "returns the created monster" do
        post :create, params: { monster: monster_params }, format: :json

        aggregate_failures do
          expect(response).to have_http_status(:created)
          json = response.parsed_body
          expect(json["name"]).to eq("Goblin")
          expect(json["current_health"]).to eq(50)
          expect(json["maximum_health"]).to eq(50)
          expect(json["experience"]).to eq(100)
          expect(json["room_id"]).to eq(room.id)
        end
      end
    end

    context "with invalid attributes" do
      let(:invalid_params) { { name: "" } }

      it "does not create a new monster" do
        expect do
          post :create, params: { monster: invalid_params }, format: :json
        end.not_to change(Monster, :count)
      end

      it "returns errors" do
        post :create, params: { monster: invalid_params }, format: :json

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "#update" do
    let!(:monster) { create(:monster, name: "Old Monster", room: room) }

    context "with valid attributes" do
      it "updates the monster" do
        patch :update, params: {
          id:      monster.id,
          monster: { name: "Updated Monster", experience: 200 }
        }, format: :json

        aggregate_failures do
          monster.reload
          expect(monster.name).to eq("Updated Monster")
          expect(monster.experience).to eq(200)
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "with invalid attributes" do
      it "returns errors" do
        patch :update, params: { id: monster.id, monster: { name: "" } }, format: :json

        aggregate_failures do
          expect(response).to have_http_status(:unprocessable_content)
          json = response.parsed_body
          expect(json["errors"]).to be_present
        end
      end
    end
  end

  describe "#destroy" do
    context "when monster has no spawn" do
      let!(:monster) { create(:monster, room: room) }

      it "destroys the monster" do
        expect do
          delete :destroy, params: { id: monster.id }, format: :json
        end.to change(Monster, :count).by(-1)
      end

      it "returns no content" do
        delete :destroy, params: { id: monster.id }, format: :json

        expect(response).to have_http_status(:no_content)
      end
    end

    context "when monster has a spawn" do
      let!(:spawn) { create(:spawn, :monster, room: room, frequency: 300) }
      let!(:monster) { spawn.entity }

      it "expires the spawn" do
        allow(Spawns::Expire).to receive(:call)

        delete :destroy, params: { id: monster.id }, format: :json

        expect(Spawns::Expire).to have_received(:call).with(spawn)
      end

      it "returns no content" do
        allow(Spawns::Expire).to receive(:call)

        delete :destroy, params: { id: monster.id }, format: :json

        expect(response).to have_http_status(:no_content)
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

describe Api::MonstersController do
  let!(:room) { create(:room) }


  describe "#create" do
    context "with valid attributes" do
      let(:monster_params) do
        {
          name: "Goblin",
          current_health: 50,
          maximum_health: 50,
          experience: 100,
          room_id: room.id
        }
      end

      it "creates a new monster" do
        expect do
          post :create, params: { monster: monster_params }, format: :json
        end.to change(Monster, :count).by(1)
      end

      it "returns the created monster" do
        post :create, params: { monster: monster_params }, format: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["name"]).to eq("Goblin")
        expect(json["current_health"]).to eq(50)
        expect(json["maximum_health"]).to eq(50)
        expect(json["experience"]).to eq(100)
        expect(json["room_id"]).to eq(room.id)
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

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "#update" do
    let!(:monster) { create(:monster, name: "Old Monster", room: room) }

    it "updates the monster" do
      patch :update, params: {
        id: monster.id,
        monster: { name: "Updated Monster", experience: 200 }
      }, format: :json

      monster.reload
      expect(monster.name).to eq("Updated Monster")
      expect(monster.experience).to eq(200)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "#destroy" do
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
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe WorldEditorsController do
  render_views

  describe "GET #show" do
    let(:room) { Room.create!(x: 0, y: 0, z: 0, description: "Test room") }

    context "when no coordinates are provided" do
      it "loads the default room coordinates" do
        get :show

        expect(response).to have_http_status(:success)
        expect(assigns(:current_room)).to be_present
        expect(assigns(:current_room).x).to eq(Room::DEFAULT_COORDINATES[:x])
        expect(assigns(:current_room).y).to eq(Room::DEFAULT_COORDINATES[:y])
        expect(assigns(:current_room).z).to eq(Room::DEFAULT_COORDINATES[:z])
      end

      it "loads surrounding rooms" do
        get :show

        expect(assigns(:surrounding_rooms)).to be_a(Hash)
        expect(assigns(:surrounding_rooms).keys).to contain_exactly(:north, :south, :east, :west, :up, :down)
      end
    end

    context "when coordinates are provided" do
      it "loads the room at the specified coordinates" do
        get :show, params: { x: room.x, y: room.y, z: room.z }

        expect(response).to have_http_status(:success)
        expect(assigns(:current_room)).to eq(room)
      end

      it "initializes a new room if not found" do
        get :show, params: { x: 5, y: 10, z: 15 }

        expect(response).to have_http_status(:success)
        expect(assigns(:current_room)).to be_new_record
        expect(assigns(:current_room).x).to eq(5)
        expect(assigns(:current_room).y).to eq(10)
        expect(assigns(:current_room).z).to eq(15)
      end
    end

    it "loads surrounding rooms correctly" do
      north_room = Room.create!(x: room.x, y: room.y + 1, z: room.z, description: "North room")
      south_room = Room.create!(x: room.x, y: room.y - 1, z: room.z, description: "South room")
      east_room = Room.create!(x: room.x + 1, y: room.y, z: room.z, description: "East room")

      get :show, params: { x: room.x, y: room.y, z: room.z }

      surrounding = assigns(:surrounding_rooms)
      expect(surrounding[:north]).to eq(north_room)
      expect(surrounding[:south]).to eq(south_room)
      expect(surrounding[:east]).to eq(east_room)
      expect(surrounding[:west]).to be_nil
      expect(surrounding[:up]).to be_nil
      expect(surrounding[:down]).to be_nil
    end
  end
end

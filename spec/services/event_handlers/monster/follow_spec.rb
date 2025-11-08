# frozen_string_literal: true

require "rails_helper"

describe EventHandlers::Monster::Follow, type: :service do
  describe ".on_character_exited" do
    subject(:on_character_exited) do
      described_class.on_character_exited(
        character: character,
        direction: direction,
        monster:   monster
      )
    end

    let(:character)   { build_stubbed(:character) }
    let(:direction)   { "north" }
    let(:room_source) { create(:room, x: 0, y: 0, z: 0) }
    let(:monster)     { create(:monster, room: room_source) }

    it "moves the monster to the target room" do
      room_target = create(:room, x: 0, y: 1, z: 0)

      on_character_exited

      expect(monster.reload.room).to eq(room_target)
    end

    context "when the monster has no room" do
      let(:monster) { create(:monster, room: nil) }

      it "does not move the monster" do
        on_character_exited

        expect(monster.reload.room).to be_nil
      end
    end

    context "when the direction is invalid" do
      let(:direction) { "invalid" }

      it "does not move the monster" do
        on_character_exited

        expect(monster.reload.room).to eq(room_source)
      end
    end

    context "when there is no room in that direction" do
      let(:direction) { "south" }

      it "does not move the monster" do
        on_character_exited

        expect(monster.reload.room).to eq(room_source)
      end
    end

    context "with different directions" do
      {
        "north" => { x: 0, y: 1, z: 0 },
        "south" => { x: 0, y: -1, z: 0 },
        "east"  => { x: 1, y: 0, z: 0 },
        "west"  => { x: -1, y: 0, z: 0 },
        "up"    => { x: 0, y: 0, z: 1 },
        "down"  => { x: 0, y: 0, z: -1 }
      }.each do |dir, coords|
        context "when moving #{dir}" do
          let(:direction) { dir }

          it "moves the monster #{dir}" do
            room_target = create(:room, **coords)

            on_character_exited

            expect(monster.reload.room).to eq(room_target)
          end
        end
      end
    end
  end
end

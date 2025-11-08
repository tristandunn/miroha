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

    let(:direction)   { "north" }
    let(:room_source) { create(:room, x: 0, y: 0, z: 0) }
    let(:room_target) { create(:room, x: 0, y: 1, z: 0) }
    let(:character)   { create(:character, room: room_target) }
    let(:monster)     { create(:monster, room: room_source) }

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_remove_to)
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
    end

    it "moves the monster to the character's room" do
      on_character_exited

      expect(monster.reload.room).to eq(room_target)
    end

    it "broadcasts the monster removal from the source room" do
      on_character_exited

      expect(Turbo::StreamsChannel).to have_received(:broadcast_remove_to)
        .with(
          room_source,
          target: "surrounding_monster_#{monster.id}"
        )
    end

    it "broadcasts the monster appearing in the target room" do
      on_character_exited

      expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to)
        .with(
          room_target,
          target:  "surrounding-monsters",
          partial: "game/surroundings/monster",
          locals:  { monster: monster }
        )
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

describe Spawns::Activate, type: :service do
  describe ".call", :freeze_time do
    it "creates a spawn entity from the base" do
      spawn = create(:spawn, :monster, entity: nil, activates_at: Time.current)

      described_class.call(spawn)

      expect(spawn.reload.entity.attributes).to include(
        spawn.base.attributes.except("id", "room_id", "created_at", "updated_at")
      )
    end

    it "assigns the spawn room to the entity" do
      spawn = create(:spawn, :monster, entity: nil, activates_at: Time.current)

      described_class.call(spawn)

      expect(spawn.reload.entity.room_id).to eq(spawn.room_id)
    end

    it "clears the activates_at attribute" do
      spawn = create(:spawn, :monster, entity: nil, activates_at: Time.current)

      described_class.call(spawn)

      expect(spawn.reload.activates_at).to be_nil
    end

    context "with a duration" do
      it "assigns an expiration time" do
        spawn = create(:spawn, :monster, entity: nil, activates_at: Time.current, duration: 1.hour)

        described_class.call(spawn)

        expect(spawn.reload.expires_at).to eq(Time.current + spawn.duration)
      end
    end

    context "without a duration" do
      it "does not assign an expiration time" do
        spawn = create(:spawn, :monster, entity: nil, activates_at: Time.current, duration: nil)

        described_class.call(spawn)

        expect(spawn.reload.expires_at).to be_nil
      end
    end

    context "with items on the base" do
      let(:base)  { create(:monster, room: nil, items: items) }
      let(:items) { build_list(:item, 2) }
      let(:spawn) { create(:spawn, base: base) }

      it "duplicates base items to the spawn entity" do
        described_class.call(spawn)

        expect(spawn.entity.items.pluck(:name)).to eq(items.map(&:name))
      end

      it "does not modify the base items" do
        described_class.call(spawn)

        expect(base.items.reload).to eq(items)
      end
    end
  end
end

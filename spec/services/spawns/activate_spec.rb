# frozen_string_literal: true

require "rails_helper"

describe Spawns::Activate, type: :service do
  describe ".call", :freeze_time do
    it "creates a spawn entity from the base" do
      spawn = create(:spawn, :monster, entity: nil, activates_at: Time.current)

      described_class.call(spawn)

      expect(spawn.reload.entity.attributes).to include(
        spawn.base.attributes.except("id", "created_at", "updated_at")
      )
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
  end
end

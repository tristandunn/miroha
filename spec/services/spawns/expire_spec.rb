# frozen_string_literal: true

require "rails_helper"

describe Spawns::Expire, type: :service do
  describe ".call", :freeze_time do
    it "destroys the entity" do
      spawn = create(:spawn, :monster, expires_at: Time.current)
      entity_id = spawn.entity_id

      described_class.call(spawn)

      expect { Monster.find(entity_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "clears the entity attributes" do
      spawn = create(:spawn, :monster, expires_at: Time.current)

      described_class.call(spawn)

      expect(spawn.reload).to have_attributes(
        entity_id:   nil,
        entity_type: nil
      )
    end

    it "clears the expires_at attribute" do
      spawn = create(:spawn, :monster, expires_at: Time.current)

      described_class.call(spawn)

      expect(spawn.reload.expires_at).to be_nil
    end

    context "with a frequency" do
      it "assigns an activation time" do
        spawn = create(:spawn, :monster, expires_at: Time.current, frequency: 1.hour)

        described_class.call(spawn)

        expect(spawn.reload.activates_at).to eq(Time.current + spawn.frequency)
      end
    end

    context "without a frequency" do
      it "does not assign an activation time" do
        spawn = create(:spawn, :monster, expires_at: Time.current, frequency: nil)

        described_class.call(spawn)

        expect(spawn.reload.activates_at).to be_nil
      end
    end
  end
end

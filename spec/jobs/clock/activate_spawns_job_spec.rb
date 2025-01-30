# frozen_string_literal: true

require "rails_helper"

describe Clock::ActivateSpawnsJob do
  describe "constants" do
    it "defines a limit" do
      expect(described_class::LIMIT).to eq(128)
    end
  end

  describe "#perform", :freeze_time do
    subject(:perform) { described_class.new.perform }

    before do
      allow(Spawns::Activate).to receive(:call)
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
    end

    context "with a spawn due to be activated" do
      it "activates the spawn" do
        spawn = create(:spawn, :monster, entity: nil, activates_at: Time.current)

        perform

        expect(Spawns::Activate).to have_received(:call).with(spawn).once
      end

      it "broadcasts the spawn to the room" do
        spawn = create(:spawn, :monster, activates_at: Time.current)

        perform

        expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to).with(
          spawn.room,
          target:  "surrounding-monsters",
          partial: "game/surroundings/monster",
          locals:  { monster: spawn.reload.entity }
        )
      end
    end

    context "with a spawn not due to be activated" do
      it "does not activate the spawn" do
        create(:spawn, :monster, entity: nil, activates_at: 1.minute.from_now)

        perform

        expect(Spawns::Activate).not_to have_received(:call)
      end

      it "does not broadcast" do
        perform

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end

    context "with an activated spawn" do
      it "does not activate the spawn" do
        create(:spawn, :monster, activates_at: nil)

        perform

        expect(Spawns::Activate).not_to have_received(:call)
      end

      it "does not broadcast" do
        perform

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end
  end
end

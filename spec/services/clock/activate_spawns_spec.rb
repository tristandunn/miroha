# frozen_string_literal: true

require "rails_helper"

describe Clock::ActivateSpawns, type: :service do
  describe ".call", :freeze_time do
    before do
      allow(Spawns::Activate).to receive(:call)
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
    end

    context "with a spawn due to be activated" do
      it "activates the spawn" do
        spawn = create(:spawn, :monster, entity: nil, activates_at: Time.current)

        described_class.call

        expect(Spawns::Activate).to have_received(:call).with(spawn).once
      end

      it "broadcasts the spawn to the room" do
        spawn = create(:spawn, :monster, activates_at: Time.current)

        described_class.call

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

        described_class.call

        expect(Spawns::Activate).not_to have_received(:call)
      end

      it "does not broadcast" do
        described_class.call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end

    context "with an activated spawn" do
      it "does not activate the spawn" do
        create(:spawn, :monster, activates_at: nil)

        described_class.call

        expect(Spawns::Activate).not_to have_received(:call)
      end

      it "does not broadcast" do
        described_class.call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end
  end
end

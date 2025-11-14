# frozen_string_literal: true

require "rails_helper"

describe Clock::ExpireSpawnsJob do
  describe "constants" do
    it "defines a limit" do
      expect(described_class::LIMIT).to eq(128)
    end
  end

  describe "#perform", :freeze_time do
    subject(:perform) { described_class.new.perform }

    before do
      allow(Spawns::Expire).to receive(:call)
      allow(Turbo::StreamsChannel).to receive(:broadcast_remove_to)
    end

    context "with a spawn due to be expired" do
      it "expires the spawn" do
        spawn = create(:spawn, :monster, expires_at: Time.current)

        perform

        expect(Spawns::Expire).to have_received(:call).with(spawn).once
      end

      it "broadcasts the despawn to the room" do
        spawn = create(:spawn, :monster, expires_at: Time.current)

        perform

        expect(Turbo::StreamsChannel).to have_received(:broadcast_remove_to).with(
          spawn.room,
          target: "surrounding_monster_#{spawn.entity.id}"
        )
      end
    end

    context "with a spawn not due to be expired" do
      it "does not expire the spawn" do
        create(:spawn, :monster, expires_at: 1.minute.from_now)

        perform

        expect(Spawns::Expire).not_to have_received(:call)
      end

      it "does not broadcast" do
        create(:spawn, :monster, expires_at: 1.minute.from_now)

        perform

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_remove_to)
      end
    end

    context "with an expired spawn" do
      it "does not expire the spawn" do
        create(:spawn, :monster, expires_at: nil)

        perform

        expect(Spawns::Expire).not_to have_received(:call)
      end

      it "does not broadcast" do
        create(:spawn, :monster, expires_at: nil)

        perform

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_remove_to)
      end
    end
  end
end

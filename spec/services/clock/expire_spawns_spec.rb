# frozen_string_literal: true

require "rails_helper"

describe Clock::ExpireSpawns, type: :service do
  describe "#call", :freeze_time do
    subject(:call) { described_class.new.call }

    before do
      allow(Spawns::Expire).to receive(:call)
    end

    context "with a spawn due to be expired" do
      it "expires the spawn" do
        spawn = create(:spawn, :monster, expires_at: Time.current)

        call

        expect(Spawns::Expire).to have_received(:call).with(spawn).once
      end
    end

    context "with a spawn not due to be expired" do
      it "does not expire the spawn" do
        create(:spawn, :monster, expires_at: 1.minute.from_now)

        call

        expect(Spawns::Expire).not_to have_received(:call)
      end
    end

    context "with an expired spawn" do
      it "does not expire the spawn" do
        create(:spawn, :monster, expires_at: nil)

        call

        expect(Spawns::Expire).not_to have_received(:call)
      end
    end
  end
end

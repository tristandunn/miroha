# frozen_string_literal: true

require "rails_helper"

describe Clock::ExpireSpawns, type: :service do
  describe ".call", :freeze_time do
    context "with a spawn due to be expire" do
      it "destroy the entity" do
        spawn = create(:spawn, :monster, expires_at: Time.current)

        described_class.call

        expect(spawn.reload.entity).to be_nil
      end

      it "clears the expires_at attribute" do
        spawn = create(:spawn, :monster, expires_at: Time.current)

        described_class.call

        expect(spawn.reload.expires_at).to be_nil
      end
    end

    context "with a spawn not due to be expired" do
      it "does not change the spawn" do
        spawn = create(:spawn, :monster, expires_at: 1.minute.from_now)

        expect { described_class.call }.not_to(change { spawn.reload.attributes })
      end
    end

    context "with an expired spawn" do
      it "does not change the spawn" do
        spawn = create(:spawn, :monster, expires_at: nil)

        expect { described_class.call }.not_to(change { spawn.reload.attributes })
      end
    end
  end
end
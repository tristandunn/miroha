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

      context "with a frequency" do
        it "assigns an activation time" do
          spawn = create(:spawn, :monster, expires_at: Time.current, frequency: 1.hour)

          described_class.call

          expect(spawn.reload.activates_at).to eq(Time.current + spawn.frequency)
        end
      end

      context "without a frequency" do
        it "does not assign an activation time" do
          spawn = create(:spawn, :monster, expires_at: Time.current, frequency: nil)

          described_class.call

          expect(spawn.reload.activates_at).to be_nil
        end
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

    context "with multiple spawns to be expired and an error" do
      let(:invalid_spawn) { build_stubbed(:spawn, :monster) }
      let(:scope)         { instance_double(ActiveRecord::Relation) }
      let(:valid_spawn)   { build_stubbed(:spawn, :monster) }

      before do
        allow(invalid_spawn).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
        allow(valid_spawn).to receive(:update!)

        allow(Sentry).to receive(:capture_exception)

        allow(Spawn).to receive(:includes).and_return(scope)
        allow(scope).to receive(:where).and_return(scope)
        allow(scope).to receive(:order).and_return(scope)
        allow(scope).to receive(:limit).with(described_class::LIMIT).and_return(scope)
        allow(scope).to receive(:find_each).and_yield(invalid_spawn).and_yield(valid_spawn)
      end

      it "reports the error" do
        described_class.call

        expect(Sentry).to have_received(:capture_exception).once
      end

      it "continues expiring other spawns" do
        described_class.call

        expect(valid_spawn).to have_received(:update!)
      end
    end
  end
end

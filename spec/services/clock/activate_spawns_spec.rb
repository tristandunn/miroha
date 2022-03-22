# frozen_string_literal: true

require "rails_helper"

describe Clock::ActivateSpawns, type: :service do
  describe ".call", :freeze_time do
    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
    end

    context "with a spawn due to be activated" do
      it "creates a spawn entity from the base" do
        spawn = create(:spawn, :monster, entity: nil, activates_at: Time.current)

        described_class.call

        expect(spawn.reload.entity.attributes).to include(
          spawn.base.attributes.except("id", "created_at", "updated_at")
        )
      end

      it "clears the activates_at attribute" do
        spawn = create(:spawn, :monster, entity: nil, activates_at: Time.current)

        described_class.call

        expect(spawn.reload.activates_at).to be_nil
      end

      it "broadcasts the spawn to the room" do
        spawn = create(:spawn, :monster, entity: nil, activates_at: Time.current)

        described_class.call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to).with(
          spawn.room,
          target:  "surrounding-monsters",
          partial: "game/surroundings/monster",
          locals:  { monster: spawn.reload.entity }
        )
      end

      context "with a duration" do
        it "assigns an expiration time" do
          spawn = create(:spawn, :monster, entity: nil, activates_at: Time.current, duration: 1.hour)

          described_class.call

          expect(spawn.reload.expires_at).to eq(Time.current + spawn.duration)
        end
      end

      context "without a duration" do
        it "does not assign an expiration time" do
          spawn = create(:spawn, :monster, entity: nil, activates_at: Time.current, duration: nil)

          described_class.call

          expect(spawn.reload.expires_at).to be_nil
        end
      end
    end

    context "with a spawn not due to be activated" do
      it "does not change the spawn" do
        spawn = create(:spawn, :monster, entity: nil, activates_at: 1.minute.from_now)

        expect { described_class.call }.not_to(change { spawn.reload.attributes })
      end

      it "does not broadcast" do
        described_class.call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end

    context "with an activated spawn" do
      it "does not change the spawn" do
        spawn = create(:spawn, :monster, activates_at: nil)

        expect { described_class.call }.not_to(change { spawn.reload.attributes })
      end

      it "does not broadcast" do
        described_class.call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end

    context "with multiple spawns to be activiated and an error" do
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

      it "continues activating other spawns" do
        described_class.call

        expect(valid_spawn).to have_received(:update!)
      end
    end
  end
end

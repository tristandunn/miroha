# frozen_string_literal: true

require "rails_helper"

describe Commands::AttackCommand, type: :service do
  let(:character) { create(:character, room: spawn.room) }
  let(:damage)    { 1 }
  let(:instance)  { described_class.new("/attack #{target.name}", character: character) }
  let(:spawn)     { create(:spawn, :monster) }
  let(:target)    { spawn.entity }

  before do
    allow(SecureRandom).to receive(:random_number).with(0..1).and_return(damage)
  end

  describe "constants" do
    it "defines custom throttle limit" do
      expect(described_class::THROTTLE_LIMIT).to eq(1)
    end

    it "defines custom throttle period" do
      expect(described_class::THROTTLE_PERIOD).to eq(1)
    end
  end

  describe "#call" do
    subject(:call) { instance.call }

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to).once
      allow(Turbo::StreamsChannel).to receive(:broadcast_render_later_to).once
    end

    context "with a valid, alive target" do
      it "broadcasts attack hit partial to the room" do
        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to)
          .with(
            character.room,
            target:  "messages",
            partial: "commands/attack/attack/hit",
            locals:  {
              attacker_name: character.name,
              character:     character,
              target_name:   target.name
            }
          )
      end

      it "damages the target" do
        expect { call }.to change { target.reload.current_health }.by(-damage)
      end
    end

    context "with a valid, missed target" do
      let(:damage) { 0 }

      it "broadcasts missed partial to the room" do
        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to)
          .with(
            character.room,
            target:  "messages",
            partial: "commands/attack/attack/missed",
            locals:  {
              attacker_name: character.name,
              character:     character,
              target_name:   target.name
            }
          )
      end

      it "does not damage the target" do
        expect { call }.not_to(change { target.reload.current_health })
      end
    end

    context "with a valid, killed target" do
      before do
        target.update!(current_health: 1, experience: 5)

        allow(Turbo::StreamsChannel).to receive(:broadcast_replace_later_to).once
      end

      it "broadcasts killed partial to the room" do
        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_render_later_to)
          .with(
            character.room,
            partial: "commands/attack/attack/killed",
            locals:  {
              attacker_name: character.name,
              character:     character,
              target_id:     target.id,
              target_name:   target.name
            }
          )
      end

      it "rewards the character experience" do
        expect { call }.to change { character.reload.experience.current }
          .from(0)
          .to(target.experience)
      end

      it "replaces experience partial for the character" do
        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_replace_later_to)
          .with(
            character,
            target:  :character,
            partial: "game/sidebar/character",
            locals:  {
              character: character
            }
          )
      end

      context "when current experience meets the needed experience" do
        before do
          character.update!(experience: 995)
        end

        it "increases the character's level" do
          expect { call }.to change { character.reload.level }.from(1).to(2)
        end
      end

      context "when current experience exceeds the needed experience" do
        before do
          character.update!(experience: 999)
        end

        it "increases the character's level" do
          expect { call }.to change { character.reload.level }.from(1).to(2)
        end

        it "retains the excess experience" do
          call

          expect(character.reload.experience.current).to eq(1_004)
        end
      end
    end

    context "with target in a different room" do
      let(:target) { create(:monster, room: create(:room)) }

      it "does not broadcast" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end

      it "does not damage the target" do
        expect { call }.not_to(change { target.reload.current_health })
      end
    end

    context "with invalid target" do
      let(:instance) { described_class.new("/attack Invalid", character: character) }

      it "does not broadcast" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end

    context "with blank target" do
      let(:instance) { described_class.new("/attack  ", character: character) }

      it "does not broadcast" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end
  end

  describe "#rendered?" do
    subject(:rendered?) { instance.rendered? }

    it { is_expected.to be(true) }
  end

  describe "#render_options" do
    subject(:render_options) { instance.render_options }

    it "returns the partial with damage and target locals" do
      expect(render_options).to eq(
        partial: "commands/attack",
        locals:  {
          damage:      damage,
          target:      target,
          target_name: target.name
        }
      )
    end
  end
end

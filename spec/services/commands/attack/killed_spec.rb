# frozen_string_literal: true

require "rails_helper"

describe Commands::Attack::Killed, type: :service do
  describe "class" do
    let(:character) { instance_double(Character) }
    let(:damage)    { 1 }
    let(:instance)  { described_class.new(character: character, damage: damage, target: target) }
    let(:target)    { build_stubbed(:monster) }

    it { expect(instance).to delegate_method(:id).to(:target).with_prefix }
    it { expect(instance).to delegate_method(:name).to(:target).with_prefix }

    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#call" do
    subject(:call) { instance.call }

    let(:character) { create(:character) }
    let(:damage)    { rand(1..10) }
    let(:instance)  { described_class.new(character: character, damage: damage, target: target) }
    let(:spawn)     { create(:spawn, :monster) }
    let(:target)    { spawn.entity }

    before do
      allow(Spawns::Expire).to receive(:call)
      allow(instance).to receive(:broadcast_render_later_to)
      allow(instance).to receive(:broadcast_replace_later_to)
    end

    it "broadcasts killed partial to the room" do
      call

      expect(instance).to have_received(:broadcast_render_later_to)
        .with(
          character.room_gid,
          partial: "commands/attack/observer/killed"
        )
    end

    it "expries the spawn" do
      call

      expect(Spawns::Expire).to have_received(:call).with(spawn)
    end

    it "rewards the character experience" do
      expect { call }.to change { character.reload.experience.current }
        .from(0)
        .to(target.experience)
    end

    it "replaces the sidebar for the character" do
      call

      expect(instance).to have_received(:broadcast_replace_later_to)
        .with(
          character,
          target:  :character,
          partial: "game/sidebar/character",
          locals:  { character: character }
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

    context "when current experience does not meet the needed experience" do
      before do
        character.update!(experience: 0)
      end

      it "does not change the character's level" do
        expect { call }.not_to(change { character.reload.level })
      end
    end
  end

  describe "#locals" do
    subject(:locals) { instance.locals }

    let(:character) { instance_double(Character) }
    let(:damage)    { rand(1..10) }
    let(:instance)  { described_class.new(character: character, damage: damage, target: target) }
    let(:target)    { instance_double(Monster, id: 1, name: "Target") }

    it do
      expect(locals).to eq(
        character:   character,
        damage:      damage,
        target_id:   target.id,
        target_name: target.name
      )
    end
  end
end

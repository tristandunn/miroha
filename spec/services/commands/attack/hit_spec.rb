# frozen_string_literal: true

require "rails_helper"

describe Commands::Attack::Hit, type: :service do
  describe "class" do
    let(:character) { instance_double(Character) }
    let(:damage)    { 1 }
    let(:instance)  { described_class.new(character: character, damage: damage, target: target) }
    let(:target)    { build_stubbed(:monster) }

    it { expect(instance).to delegate_method(:name).to(:target).with_prefix }

    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#call" do
    subject(:call) { instance.call }

    let(:character) { instance_double(Character, room_gid: room_gid, name: "Character") }
    let(:damage)    { rand(1..2) }
    let(:instance)  { described_class.new(character: character, damage: damage, target: target) }
    let(:room_gid)  { SecureRandom.hex }
    let(:target)    { create(:monster) }

    before do
      allow(instance).to receive(:broadcast_append_later_to)
      allow(target).to receive(:trigger)
    end

    it "damages the target" do
      expect { call }.to change { target.reload.current_health }.by(-damage)
    end

    it "notifies the target of being attacked" do
      call

      expect(target).to have_received(:trigger)
        .with(:attacked, character: character, damage: damage)
    end

    it "broadcasts attack hit partial to the room" do
      call

      expect(instance).to have_received(:broadcast_append_later_to)
        .with(
          character.room_gid,
          target:  :messages,
          partial: "commands/attack/observer/hit"
        )
    end
  end

  describe "#locals" do
    subject(:locals) { instance.locals }

    let(:character) { instance_double(Character) }
    let(:damage)    { rand(1..10) }
    let(:instance)  { described_class.new(character: character, damage: damage, target: target) }
    let(:target)    { instance_double(Monster, name: "Target") }

    it do
      expect(locals).to eq(
        character:   character,
        damage:      damage,
        target_name: target.name
      )
    end
  end
end

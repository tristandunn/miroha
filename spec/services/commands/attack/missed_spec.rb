# frozen_string_literal: true

require "rails_helper"

describe Commands::Attack::Missed, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#call" do
    subject(:call) { instance.call }

    let(:character) { instance_double(Character, room_gid: room_gid, name: "Character") }
    let(:instance)  { described_class.new(character: character, target: target) }
    let(:room_gid)  { SecureRandom.hex }
    let(:target)    { instance_double(Monster, name: "Target") }

    before do
      allow(instance).to receive(:broadcast_append_later_to)
    end

    it "broadcasts missed partial to the room" do
      call

      expect(instance).to have_received(:broadcast_append_later_to)
        .with(
          character.room_gid,
          target:  :messages,
          partial: "commands/attack/observer/missed"
        )
    end
  end

  describe "#locals" do
    subject(:locals) { instance.locals }

    let(:character) { instance_double(Character) }
    let(:instance)  { described_class.new(character: character, target: target) }
    let(:target)    { instance_double(Monster, name: "Target") }

    it do
      expect(locals).to eq(
        character:   character,
        target_name: target.name
      )
    end
  end
end

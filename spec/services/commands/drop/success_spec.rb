# frozen_string_literal: true

require "rails_helper"

describe Commands::Drop::Success, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#call" do
    subject(:call) { instance.call }

    let(:character) { create(:character, room: room) }
    let(:instance)  { described_class.new(character: character, item: item) }
    let(:item)      { create(:item, owner: character) }
    let(:room)      { create(:room) }

    before do
      allow(instance).to receive(:broadcast_render_later_to)
    end

    it "transfers ownership to the room" do
      expect { call }.to change { item.reload.owner }.from(character).to(room)
    end

    it "broadcasts drop observer message to the room" do
      call

      expect(instance).to have_received(:broadcast_render_later_to)
        .with(
          character.room_gid,
          partial: "commands/drop/observer/success",
          locals:  { character: character, item: item }
        )
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:character) { double }
    let(:instance)  { described_class.new(character: character, item: item) }
    let(:item)      { double }

    it { is_expected.to eq(character: character, item: item) }
  end
end

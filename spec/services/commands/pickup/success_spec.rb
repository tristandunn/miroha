# frozen_string_literal: true

require "rails_helper"

describe Commands::Pickup::Success, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#call" do
    subject(:call) { instance.call }

    let(:character) { create(:character, room: room) }
    let(:instance)  { described_class.new(character: character, item: item) }
    let(:item)      { create(:item, owner: room) }
    let(:room)      { create(:room) }

    before do
      allow(instance).to receive(:broadcast_render_later_to)
    end

    context "with a non-stackable item" do
      it "transfers ownership to the character" do
        expect { call }.to change { item.reload.owner }.from(room).to(character)
      end

      it "broadcasts pickup observer message to the room" do
        call

        expect(instance).to have_received(:broadcast_render_later_to)
          .with(
            character.room_gid,
            partial: "commands/pickup/observer/success",
            locals:  { character: character, item: item }
          )
      end
    end

    context "with a stackable item" do
      let(:item) { create(:item, :stackable, owner: room, quantity: 2) }
      let(:stacker) { instance_double(ItemStacker) }

      before do
        allow(ItemStacker).to receive(:new).with(character: character, item: item).and_return(stacker)
        allow(stacker).to receive(:call)
      end

      it "creates an ItemStacker with the character and item" do
        call

        expect(ItemStacker).to have_received(:new).with(character: character, item: item)
      end

      it "calls the ItemStacker" do
        call

        expect(stacker).to have_received(:call)
      end

      it "broadcasts pickup observer message to the room" do
        call

        expect(instance).to have_received(:broadcast_render_later_to)
          .with(
            character.room_gid,
            partial: "commands/pickup/observer/success",
            locals:  { character: character, item: item }
          )
      end
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

# frozen_string_literal: true

require "rails_helper"

describe Commands::Use::Success, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#call" do
    subject(:call) { instance.call }

    let(:character) { create(:character, room: room, current_health: 5, maximum_health: 10) }
    let(:instance)  { described_class.new(character: character, item: item) }
    let(:item)      { create(:item, owner: character, metadata: { "consumable" => true, "heal_amount" => 3 }) }
    let(:room)      { create(:room) }

    before do
      allow(instance).to receive(:broadcast_render_later_to)
    end

    it "restores character health" do
      expect { call }.to change { character.reload.current_health }.from(5).to(8)
    end

    it "destroys the item when not stackable" do
      expect { call }.to change(Item, :count).by(-1)
    end

    it "broadcasts use observer message to the room" do
      call

      expect(instance).to have_received(:broadcast_render_later_to)
        .with(
          character.room_gid,
          partial: "commands/use/observer/success",
          locals:  { character: character, name: item.name }
        )
    end

    context "with stackable item" do
      let(:item) { create(:item, :stackable, owner: character, quantity: 3, metadata: { "consumable" => true, "heal_amount" => 2, "stack_limit" => 5 }) }

      it "restores character health" do
        expect { call }.to change { character.reload.current_health }.from(5).to(7)
      end

      it "decrements item quantity" do
        expect { call }.to change { item.reload.quantity }.from(3).to(2)
      end

      it "does not destroy the item" do
        expect { call }.not_to change(Item, :count)
      end

      it "broadcasts use observer message to the room" do
        call

        expect(instance).to have_received(:broadcast_render_later_to)
          .with(
            character.room_gid,
            partial: "commands/use/observer/success",
            locals:  { character: character, name: item.name }
          )
      end

      context "with quantity of 1" do
        let(:item) { create(:item, :stackable, owner: character, quantity: 1, metadata: { "consumable" => true, "heal_amount" => 2, "stack_limit" => 5 }) }

        it "destroys the item" do
          expect { call }.to change(Item, :count).by(-1)
        end
      end
    end

    context "when health restoration would exceed maximum" do
      let(:character) { create(:character, room: room, current_health: 8, maximum_health: 10) }
      let(:item)      { create(:item, owner: character, metadata: { "consumable" => true, "heal_amount" => 5 }) }

      it "restores health up to maximum only" do
        expect { call }.to change { character.reload.current_health }.from(8).to(10)
      end

      it "broadcasts observer message to the room" do
        call

        expect(instance).to have_received(:broadcast_render_later_to)
          .with(
            character.room_gid,
            partial: "commands/use/observer/success",
            locals:  { character: character, name: item.name }
          )
      end
    end

    context "when character is at full health" do
      let(:character) { create(:character, room: room, current_health: 10, maximum_health: 10) }
      let(:item)      { create(:item, owner: character, metadata: { "consumable" => true, "heal_amount" => 5 }) }

      it "does not restore any health" do
        expect { call }.not_to change { character.reload.current_health }
      end

      it "still destroys the item" do
        expect { call }.to change(Item, :count).by(-1)
      end

      it "broadcasts observer message to the room" do
        call

        expect(instance).to have_received(:broadcast_render_later_to)
          .with(
            character.room_gid,
            partial: "commands/use/observer/success",
            locals:  { character: character, name: item.name }
          )
      end
    end

    context "when item has no heal_amount" do
      let(:item) { create(:item, owner: character, metadata: { "consumable" => true }) }

      it "does not restore any health" do
        expect { call }.not_to change { character.reload.current_health }
      end

      it "still destroys the item" do
        expect { call }.to change(Item, :count).by(-1)
      end
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:character)       { create(:character, room: create(:room), current_health: 5, maximum_health: 10) }
    let(:health_restored) { 3 }
    let(:instance)        { described_class.new(character: character, item: item) }
    let(:item)            { create(:item, owner: character, metadata: { "consumable" => true, "heal_amount" => health_restored }) }

    before do
      allow(instance).to receive(:broadcast_render_later_to)
      instance.call
    end

    it { is_expected.to eq(character: character, item: item, health_restored: health_restored) }
  end
end

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

      context "when character has no existing stacks" do
        it "transfers the item to the character" do
          expect { call }.to change { character.items.count }.by(1)
        end

        it "preserves the item quantity" do
          call
          expect(character.items.first.quantity).to eq(2)
        end

        it "destroys the original item" do
          call
          expect { item.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "when character has an existing stack with available space" do
        let!(:existing_stack) { create(:item, :stackable, owner: character, name: item.name, quantity: 2) }

        it "merges into the existing stack" do
          expect { call }.not_to(change { character.items.count })
        end

        it "increases the existing stack quantity" do
          expect { call }.to change { existing_stack.reload.quantity }.from(2).to(4)
        end

        it "destroys the original item" do
          call
          expect { item.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "when character has a full stack" do
        let!(:full_stack) { create(:item, :stackable, owner: character, name: item.name, quantity: 5) }

        it "creates a new stack" do
          expect { call }.to change { character.items.count }.by(1)
        end

        it "does not modify the full stack" do
          expect { call }.not_to(change { full_stack.reload.quantity })
        end

        it "creates new stack with correct quantity" do
          call
          new_stack = character.items.where.not(id: full_stack.id).first
          expect(new_stack.quantity).to eq(2)
        end
      end

      context "when character has partial stack and picks up more than remaining space" do
        let(:item) { create(:item, :stackable, owner: room, quantity: 4) }
        let!(:partial_stack) { create(:item, :stackable, owner: character, name: item.name, quantity: 3) }

        it "fills the existing stack and creates a new one" do
          expect { call }.to change { character.items.count }.by(1)
        end

        it "fills the existing stack to max" do
          expect { call }.to change { partial_stack.reload.quantity }.from(3).to(5)
        end

        it "creates new stack with remaining quantity" do
          call
          new_stack = character.items.where.not(id: partial_stack.id).first
          expect(new_stack.quantity).to eq(2)
        end
      end

      # rubocop:disable RSpec/MultipleMemoizedHelpers
      context "when character has multiple partial stacks and picks up exact amount to fill one" do
        let(:item) { create(:item, :stackable, owner: room, quantity: 2) }
        let!(:smallest_stack) { create(:item, :stackable, owner: character, name: item.name, quantity: 3) }
        let!(:larger_stack) { create(:item, :stackable, owner: character, name: item.name, quantity: 4) }

        it "fills only the first partial stack" do
          expect { call }.not_to(change { character.items.count })
        end

        it "updates the smallest stack quantity" do
          expect { call }.to change { smallest_stack.reload.quantity }.from(3).to(5)
        end

        it "does not modify the larger stack" do
          expect { call }.not_to(change { larger_stack.reload.quantity })
        end
      end
      # rubocop:enable RSpec/MultipleMemoizedHelpers
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

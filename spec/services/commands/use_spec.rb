# frozen_string_literal: true

require "rails_helper"

describe Commands::Use, type: :service do
  let(:character) { create(:character) }
  let(:instance)  { described_class.new("/use #{item.name}", character: character) }
  let(:item)      { create(:item, owner: character, metadata: { "consumable" => true, "health" => 5 }) }

  describe "#call" do
    subject(:call) { instance.call }

    context "with a valid consumable item" do
      let(:result) { instance_double(described_class::Success) }

      before do
        allow(result).to receive(:call)
        allow(described_class::Success).to receive(:new)
          .with(character: character, item: item)
          .and_return(result)
      end

      it "delegates to success handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with partial item name match" do
      let(:instance) { described_class.new("/use #{item.name.slice(0, 2)}", character: character) }
      let(:result)   { instance_double(described_class::Success) }

      before do
        allow(result).to receive(:call)
        allow(described_class::Success).to receive(:new)
          .with(character: character, item: item)
          .and_return(result)
      end

      it "delegates to success handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with case insensitive item name" do
      let(:instance) { described_class.new("/use #{item.name.upcase}", character: character) }
      let(:result)   { instance_double(described_class::Success) }

      before do
        allow(result).to receive(:call)
        allow(described_class::Success).to receive(:new)
          .with(character: character, item: item)
          .and_return(result)
      end

      it "delegates to success handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with multiple matching items" do
      let(:result) { instance_double(described_class::Success) }

      before do
        create(:item, owner: character, name: item.name, quantity: 2, metadata: { "consumable" => true, "health" => 5, "stack_limit" => 5 })

        allow(result).to receive(:call)
        allow(described_class::Success).to receive(:new)
          .with(character: character, item: item)
          .and_return(result)
      end

      it "delegates to success handler for the item with lowest quantity" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with item not in character's inventory" do
      let(:item)   { create(:item, :room, metadata: { "consumable" => true, "health" => 5 }) }
      let(:result) { instance_double(described_class::InvalidItem) }

      before do
        allow(result).to receive(:call)
        allow(described_class::InvalidItem).to receive(:new)
          .with(name: item.name)
          .and_return(result)
      end

      it "delegates to invalid item handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with invalid item name" do
      let(:instance) { described_class.new("/use Unknown", character: character) }
      let(:result)   { instance_double(described_class::InvalidItem) }

      before do
        allow(result).to receive(:call)
        allow(described_class::InvalidItem).to receive(:new)
          .with(name: "Unknown")
          .and_return(result)
      end

      it "delegates to invalid item handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with blank item name" do
      let(:instance) { described_class.new("/use ", character: character) }
      let(:result)   { instance_double(described_class::MissingItem) }

      before do
        allow(result).to receive(:call)
        allow(described_class::MissingItem).to receive(:new)
          .with(no_args)
          .and_return(result)
      end

      it "delegates to missing item handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with non-consumable item" do
      let(:item)   { create(:item, owner: character, metadata: {}) }
      let(:result) { instance_double(described_class::NotConsumable) }

      before do
        allow(result).to receive(:call)
        allow(described_class::NotConsumable).to receive(:new)
          .with(item: item)
          .and_return(result)
      end

      it "delegates to not consumable handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with item marked as not consumable" do
      let(:item)   { create(:item, owner: character, metadata: { "consumable" => false }) }
      let(:result) { instance_double(described_class::NotConsumable) }

      before do
        allow(result).to receive(:call)
        allow(described_class::NotConsumable).to receive(:new)
          .with(item: item)
          .and_return(result)
      end

      it "delegates to not consumable handler" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end
  end
end

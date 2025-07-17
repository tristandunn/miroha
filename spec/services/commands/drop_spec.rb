# frozen_string_literal: true

require "rails_helper"

describe Commands::Drop, type: :service do
  let(:character) { create(:character) }
  let(:instance)  { described_class.new("/drop #{item.name}", character: character) }
  let(:item)      { create(:item, owner: character) }

  describe "#call" do
    subject(:call) { instance.call }

    context "with a valid item" do
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
      let(:instance) { described_class.new("/drop #{item.name.slice(0, 2)}", character: character) }
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
      let(:instance) { described_class.new("/drop #{item.name.upcase}", character: character) }
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
        create(:item, owner: character, name: item.name)

        allow(result).to receive(:call)
        allow(described_class::Success).to receive(:new)
          .with(character: character, item: item)
          .and_return(result)
      end

      it "delegates to success handler for the first matching item" do
        call

        expect(result).to have_received(:call).with(no_args)
      end
    end

    context "with item not in character's inventory" do
      let(:item)   { create(:item, :room) }
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
      let(:instance) { described_class.new("/drop Unknown", character: character) }
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
      let(:instance) { described_class.new("/drop ", character: character) }
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
  end
end

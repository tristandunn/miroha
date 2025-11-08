# frozen_string_literal: true

require "rails_helper"

describe Item do
  describe "associations" do
    subject(:item) { create(:item, :room) }

    it { is_expected.to belong_to(:owner).optional(true) }
  end

  describe "validations" do
    subject(:item) { create(:item, :room) }

    it { is_expected.to validate_presence_of(:name) }

    it do
      expect(item).to validate_length_of(:name)
        .is_at_least(described_class::MINIMUM_NAME_LENGTH)
        .is_at_most(described_class::MAXIMUM_NAME_LENGTH)
    end

    it { is_expected.to validate_numericality_of(:quantity).only_integer.is_greater_than(0) }

    context "when quantity exceeds max_stack" do
      subject(:item) { build(:item, :room, :stackable, quantity: 10) }

      it "is invalid" do
        expect(item).not_to be_valid
      end

      it "has an error on quantity" do
        item.valid?
        expect(item.errors[:quantity]).to include("cannot exceed maximum stack size of 5")
      end
    end
  end

  describe "#max_stack" do
    context "when metadata has max_stack" do
      subject(:item) { create(:item, :room, :stackable) }

      it "returns the metadata max_stack value" do
        expect(item.max_stack).to eq(5)
      end
    end

    context "when metadata does not have max_stack" do
      subject(:item) { create(:item, :room) }

      it "returns the default max_stack" do
        expect(item.max_stack).to eq(described_class::DEFAULT_MAX_STACK)
      end
    end
  end

  describe "#stackable?" do
    context "when max_stack is greater than 1" do
      subject(:item) { create(:item, :room, :stackable) }

      it "returns true" do
        expect(item).to be_stackable
      end
    end

    context "when max_stack is 1" do
      subject(:item) { create(:item, :room) }

      it "returns false" do
        expect(item).not_to be_stackable
      end
    end
  end

  describe "#can_stack_more?" do
    context "when quantity is less than max_stack" do
      subject(:item) { create(:item, :room, :stackable, quantity: 3) }

      it "returns true" do
        expect(item.can_stack_more?).to be(true)
      end
    end

    context "when quantity equals max_stack" do
      subject(:item) { create(:item, :room, :stackable, quantity: 5) }

      it "returns false" do
        expect(item.can_stack_more?).to be(false)
      end
    end
  end

  describe "#available_stack_space" do
    subject(:item) { create(:item, :room, :stackable, quantity: 3) }

    it "returns the remaining space in the stack" do
      expect(item.available_stack_space).to eq(2)
    end
  end
end

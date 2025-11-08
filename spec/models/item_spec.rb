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

    context "when quantity exceeds stack_limit" do
      subject(:item) { build(:item, :room, :stackable, quantity: 10) }

      it "is invalid" do
        expect(item).not_to be_valid
      end

      it "has an error on quantity" do
        item.valid?
        expect(item.errors[:quantity]).to include("must be less than or equal to 5")
      end
    end
  end

  describe "#stack_limit" do
    context "when metadata has stack_limit" do
      subject(:item) { create(:item, :room, :stackable) }

      it "returns the metadata stack_limit value" do
        expect(item.stack_limit).to eq(5)
      end
    end

    context "when metadata does not have stack_limit" do
      subject(:item) { create(:item, :room) }

      it "returns the default stack_limit" do
        expect(item.stack_limit).to eq(described_class::DEFAULT_STACK_LIMIT)
      end
    end
  end

  describe "#stackable?" do
    context "when stack_limit is greater than 1" do
      subject(:item) { create(:item, :room, :stackable) }

      it "returns true" do
        expect(item).to be_stackable
      end
    end

    context "when stack_limit is 1" do
      subject(:item) { create(:item, :room) }

      it "returns false" do
        expect(item).not_to be_stackable
      end
    end
  end

end

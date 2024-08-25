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
  end
end

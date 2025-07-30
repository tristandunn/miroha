# frozen_string_literal: true

require "rails_helper"

describe Npc do
  describe "associations" do
    it { is_expected.to belong_to(:room).optional }

    it "has one :spawn foreign_key: :entity_id, dependent: :nullify" do
      expect(build(:npc)).to have_one(:spawn)
        .with_foreign_key(:entity_id)
        .dependent(:nullify)
    end
  end

  describe "validations" do
    subject(:npc) { build(:npc) }

    it { is_expected.to validate_presence_of(:name) }

    it "is expected to validate that the length of :name is between the minimum and maximum" do
      expect(npc).to validate_length_of(:name)
        .is_at_least(described_class::MINIMUM_NAME_LENGTH)
        .is_at_most(described_class::MAXIMUM_NAME_LENGTH)
    end
  end
end

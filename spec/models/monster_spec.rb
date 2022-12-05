# frozen_string_literal: true

require "rails_helper"

describe Monster do
  describe "class" do
    subject { described_class }

    it { is_expected.to include(Dispatchable) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:room).optional }

    it "has one :spawn foreign_key: :entity_id, dependent: :nullify" do
      expect(build(:monster)).to have_one(:spawn)
        .with_foreign_key(:entity_id)
        .dependent(:nullify)
    end
  end

  describe "validations" do
    subject(:monster) { build(:monster) }

    it { is_expected.to validate_numericality_of(:current_health).is_greater_than(0).only_integer }

    it { is_expected.to validate_presence_of(:experience) }
    it { is_expected.to validate_numericality_of(:experience).is_greater_than(0).only_integer }

    it { is_expected.to validate_numericality_of(:maximum_health).is_greater_than(0).only_integer }

    it { is_expected.to validate_presence_of(:name) }

    it "validates that :current_health is less than or equal to :maximum_health" do
      expect(monster).to validate_numericality_of(:current_health)
        .is_less_than_or_equal_to(monster.maximum_health)
    end

    it "is expected to validate that the length of :name is between the minimum and maximum" do
      expect(monster).to validate_length_of(:name)
        .is_at_least(described_class::MINIMUM_NAME_LENGTH)
        .is_at_most(described_class::MAXIMUM_NAME_LENGTH)
    end
  end
end

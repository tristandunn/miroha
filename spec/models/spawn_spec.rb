# frozen_string_literal: true

require "rails_helper"

describe Spawn do
  describe "associations" do
    it { is_expected.to belong_to(:base) }
    it { is_expected.to belong_to(:entity).dependent(:destroy).optional(true) }
    it { is_expected.to belong_to(:room) }
  end

  describe "validations" do
    subject(:spawn) { build(:spawn) }

    it { is_expected.to allow_value(build(:monster, room: nil)).for(:base).on(:create) }
    it { is_expected.not_to allow_value(build(:monster, room: build(:room))).for(:base).on(:create) }

    it "validates that :duration looks like an integer greater than zero, allowing nil" do
      expect(spawn).to validate_numericality_of(:duration)
        .is_greater_than(0)
        .only_integer
        .allow_nil
    end

    it "validates that :frequency looks like an integer greater than zero, allowing nil" do
      expect(spawn).to validate_numericality_of(:frequency)
        .is_greater_than(0)
        .only_integer
        .allow_nil
    end
  end
end

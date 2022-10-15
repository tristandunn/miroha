# frozen_string_literal: true

require "rails_helper"

describe Spawn, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:base) }
    it { is_expected.to belong_to(:entity).dependent(:destroy).optional(true) }
    it { is_expected.to belong_to(:room) }
  end

  describe "validations" do
    it { is_expected.to allow_value(build(:monster, room: nil)).for(:base).on(:create) }
    it { is_expected.not_to allow_value(build(:monster, room: build(:room))).for(:base).on(:create) }
  end
end

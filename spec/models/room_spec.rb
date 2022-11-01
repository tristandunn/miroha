# frozen_string_literal: true

require "rails_helper"

describe Room do
  describe "associations" do
    subject(:room) { build(:room) }

    it "has many :characters dependent: :restrict_with_exception" do
      expect(room).to have_many(:characters).dependent(:restrict_with_exception)
    end
  end

  describe "validations" do
    subject(:room) { build(:room) }

    it { is_expected.to have_many(:monsters).dependent(:destroy) }
    it { is_expected.to have_many(:spawns).dependent(:destroy) }

    it { is_expected.to validate_presence_of(:description) }

    it { is_expected.to validate_numericality_of(:x).only_integer }
    it { is_expected.to validate_uniqueness_of(:x).scoped_to(:y, :z) }

    it { is_expected.to validate_numericality_of(:y).only_integer }

    it { is_expected.to validate_numericality_of(:z).only_integer }
  end
end

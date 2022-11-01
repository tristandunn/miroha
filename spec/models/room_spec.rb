# frozen_string_literal: true

require "rails_helper"

describe Room do
  describe "associations" do
    subject(:room) { build(:room) }

    it "has many :characters dependent: :restrict_with_exception" do
      expect(room).to have_many(:characters).dependent(:restrict_with_exception)
    end
  end

  describe "constants" do
    it "defines default room coordinates" do
      expect(described_class::DEFAULT_COORDINATES).to eq(x: 0, y: 0, z: 0)
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

  describe ".default" do
    subject(:default) { described_class.default }

    let(:room) { build_stubbed(:room) }

    before do
      allow(described_class).to receive(:find_by)
        .with(described_class::DEFAULT_COORDINATES)
        .and_return(room)
    end

    it "returns the default room" do
      expect(default).to eq(room)
    end
  end
end

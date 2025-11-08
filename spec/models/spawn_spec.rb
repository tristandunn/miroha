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

  describe "#hate_duration" do
    subject(:spawn) { build(:spawn, metadata: metadata) }

    context "when metadata does not contain hate_duration" do
      let(:metadata) { {} }

      it "returns the default duration of 300 seconds (5 minutes)" do
        expect(spawn.hate_duration).to eq(300)
      end
    end

    context "when metadata contains a valid hate_duration" do
      let(:metadata) { { "hate_duration" => 600 } }

      it "returns the configured duration" do
        expect(spawn.hate_duration).to eq(600)
      end
    end

    context "when hate_duration is below the minimum (30 seconds)" do
      let(:metadata) { { "hate_duration" => 10 } }

      it "returns the minimum duration of 30 seconds" do
        expect(spawn.hate_duration).to eq(30)
      end
    end

    context "when hate_duration is above the maximum (3600 seconds / 1 hour)" do
      let(:metadata) { { "hate_duration" => 7200 } }

      it "returns the maximum duration of 3600 seconds" do
        expect(spawn.hate_duration).to eq(3600)
      end
    end

    context "when hate_duration is a string" do
      let(:metadata) { { "hate_duration" => "120" } }

      it "converts to integer and returns the duration" do
        expect(spawn.hate_duration).to eq(120)
      end
    end
  end
end

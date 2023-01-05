# frozen_string_literal: true

require "rails_helper"

describe Character do
  describe "associations" do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:room) }
  end

  describe "validations" do
    subject(:character) { build(:character) }

    it { is_expected.to validate_numericality_of(:current_health).is_greater_than(0).only_integer }

    it { is_expected.to validate_numericality_of(:maximum_health).is_greater_than(0).only_integer }

    it { is_expected.to validate_presence_of(:level) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

    it "validates that :current_health is less than or equal to :maximum_health" do
      expect(character).to validate_numericality_of(:current_health)
        .is_less_than_or_equal_to(character.maximum_health)
    end

    it "validates that :experience looks like an integer greater than or equal to 0" do
      expect(character).to validate_numericality_of(:experience)
        .is_greater_than_or_equal_to(0)
        .only_integer
    end

    it "validates that :level looks like an integer greater than or equal to 1" do
      expect(character).to validate_numericality_of(:level)
        .is_greater_than_or_equal_to(1)
        .only_integer
    end

    it "is expected to validate that the length of :name is between the minimum and maximum" do
      expect(character).to validate_length_of(:name)
        .is_at_least(described_class::MINIMUM_NAME_LENGTH)
        .is_at_most(described_class::MAXIMUM_NAME_LENGTH)
    end
  end

  describe ".active" do
    subject(:active) { described_class.active }

    it "returns characters active within the last 15 minutes" do
      character_1 = create(:character, active_at: 1.minute.ago)
      character_2 = create(:character, active_at: described_class::ACTIVE_DURATION.ago)
      create(:character, active_at: described_class::ACTIVE_DURATION.ago - 1.second)

      expect(active).to match_array([character_1, character_2])
    end
  end

  describe ".inactive" do
    subject(:inactive) { described_class.inactive }

    it "returns characters inactive outside the last 15 minutes" do
      create(:character, active_at: 1.minute.ago)
      create(:character, active_at: described_class::ACTIVE_DURATION.ago)
      character = create(:character, active_at: described_class::ACTIVE_DURATION.ago - 1.second)

      expect(inactive).to match_array([character])
    end
  end

  describe ".playing" do
    subject(:playing) { described_class.playing }

    it "returns playing characters" do
      create(:character, playing: false)
      character = create(:character, playing: true)

      expect(playing).to match_array([character])
    end
  end

  describe "#experience" do
    subject(:experience) { character.experience }

    let(:character) { build_stubbed(:character) }
    let(:instance)  { instance_double(Experience) }

    before do
      allow(Experience).to receive(:new)
        .with({ current: character[:experience], level: character[:level] })
        .and_return(instance)
    end

    it { is_expected.to eq(instance) }
  end

  describe "#health" do
    subject(:health) { character.health }

    let(:character) { build_stubbed(:character) }
    let(:instance)  { instance_double(HitPoints) }

    before do
      allow(HitPoints).to receive(:new)
        .with({ current: character.current_health, maximum: character.maximum_health })
        .and_return(instance)
    end

    it { is_expected.to eq(instance) }
  end

  describe "#inactive?", :freeze_time do
    subject(:inactive?) { character.inactive? }

    context "when not active within the duration" do
      let(:character) { create(:character, :inactive) }

      it { is_expected.to be(true) }
    end

    context "when active within the duration" do
      let(:character) { create(:character) }

      it { is_expected.to be(false) }
    end
  end

  describe "#recent?", cache: true do
    subject(:recent?) { character.recent? }

    let(:character) { create(:character) }

    context "when recently selected" do
      before do
        Rails.cache.write(described_class::SELECTED_KEY % character.id, 1, expires_in: 5.minutes)
      end

      it { is_expected.to be(true) }
    end

    context "when not recently selected" do
      it { is_expected.to be(false) }
    end
  end
end

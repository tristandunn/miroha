# frozen_string_literal: true

require "rails_helper"

describe Character, type: :model do
  subject(:character) { create(:character) }

  it { is_expected.to belong_to(:account) }
  it { is_expected.to belong_to(:room) }

  it { is_expected.to validate_presence_of(:current_health) }
  it { is_expected.to validate_numericality_of(:current_health).only_integer }

  it { is_expected.to validate_presence_of(:maximum_health) }
  it { is_expected.to validate_numericality_of(:maximum_health).only_integer }

  it { is_expected.to validate_presence_of(:level) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  it do
    expect(character).to validate_numericality_of(:experience)
      .is_greater_than_or_equal_to(0)
      .only_integer
  end

  it do
    expect(character).to validate_numericality_of(:level)
      .is_greater_than_or_equal_to(1)
      .only_integer
  end

  it do
    expect(character).to validate_length_of(:name)
      .is_at_least(described_class::MINIMUM_NAME_LENGTH)
      .is_at_most(described_class::MAXIMUM_NAME_LENGTH)
  end

  describe ".active", type: :model do
    subject(:active) { described_class.active }

    it "returns characters active within the last 15 minutes" do
      character_1 = create(:character, active_at: 1.minute.ago)
      character_2 = create(:character, active_at: described_class::ACTIVE_DURATION.ago)
      create(:character, active_at: described_class::ACTIVE_DURATION.ago - 1.second)

      expect(active).to match_array([character_1, character_2])
    end
  end

  describe ".inactive", type: :model do
    subject(:inactive) { described_class.inactive }

    it "returns characters inactive outside the last 15 minutes" do
      create(:character, active_at: 1.minute.ago)
      create(:character, active_at: described_class::ACTIVE_DURATION.ago)
      character = create(:character, active_at: described_class::ACTIVE_DURATION.ago - 1.second)

      expect(inactive).to match_array([character])
    end
  end

  describe ".playing", type: :model do
    subject(:playing) { described_class.playing }

    it "returns playing characters" do
      create(:character, playing: false)
      character = create(:character, playing: true)

      expect(playing).to match_array([character])
    end
  end

  describe "#experience" do
    subject(:experience) { character.experience }

    let(:instance) { instance_double(Experience) }

    before do
      allow(Experience).to receive(:new)
        .with(current: character[:experience], level: character[:level])
        .and_return(instance)
    end

    it { is_expected.to eq(instance) }
  end

  describe "#health" do
    subject(:health) { character.health }

    let(:instance) { instance_double(HitPoints) }

    before do
      allow(HitPoints).to receive(:new)
        .with(current: character.current_health, maximum: character.maximum_health)
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

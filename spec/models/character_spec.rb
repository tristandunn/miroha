# frozen_string_literal: true

require "rails_helper"

describe Character, type: :model do
  subject(:character) { create(:character) }

  it { is_expected.to belong_to(:account) }
  it { is_expected.to belong_to(:room) }

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

  describe "#experience" do
    subject(:experience) { character.experience }

    let(:instance) { instance_double(Experience) }

    before do
      allow(Experience).to receive(:new)
        .with(experience: character[:experience], level: character[:level])
        .and_return(instance)
    end

    it { is_expected.to eq(instance) }
  end
end

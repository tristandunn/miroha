# frozen_string_literal: true

require "rails_helper"

describe Character, type: :model do
  subject(:character) { create(:character) }

  it { is_expected.to belong_to(:account) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  it do
    expect(character).to validate_length_of(:name)
      .is_at_least(described_class::MINIMUM_NAME_LENGTH)
      .is_at_most(described_class::MAXIMUM_NAME_LENGTH)
  end
end

# frozen_string_literal: true

require "rails_helper"

describe Monster, type: :model do
  subject(:monster) { create(:monster) }

  it do
    expect(monster).to have_one(:spawn)
      .with_foreign_key(:entity_id)
      .dependent(:nullify)
  end

  it { is_expected.to validate_presence_of(:name) }

  it do
    expect(monster).to validate_length_of(:name)
      .is_at_least(described_class::MINIMUM_NAME_LENGTH)
      .is_at_most(described_class::MAXIMUM_NAME_LENGTH)
  end
end

# frozen_string_literal: true

require "rails_helper"

describe Room, type: :model do
  subject(:room) { create(:room) }

  it do
    expect(room).to have_many(:characters).dependent(:restrict_with_exception)
  end

  it { is_expected.to have_many(:monsters).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:description) }

  it { is_expected.to validate_numericality_of(:x).only_integer }
  it { is_expected.to validate_uniqueness_of(:x).scoped_to(:y, :z) }

  it { is_expected.to validate_numericality_of(:y).only_integer }

  it { is_expected.to validate_numericality_of(:z).only_integer }
end

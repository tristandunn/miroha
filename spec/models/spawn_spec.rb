# frozen_string_literal: true

require "rails_helper"

describe Spawn, type: :model do
  it { is_expected.to belong_to(:base) }
  it { is_expected.to belong_to(:entity).dependent(:destroy).optional(true) }
  it { is_expected.to belong_to(:room) }
end

# frozen_string_literal: true

class Monster < ApplicationRecord
  include Dispatchable

  MINIMUM_NAME_LENGTH = 3
  MAXIMUM_NAME_LENGTH = 24

  has_one :spawn, foreign_key: :entity_id, inverse_of: :entity, dependent: :nullify
  has_many :items, as: :owner, dependent: :destroy

  belongs_to :room, optional: true

  validates :current_health, numericality: {
    less_than_or_equal_to: :maximum_health, greater_than: 0, only_integer: true
  }
  validates :experience, presence:     true,
                         numericality: { greater_than: 0, only_integer: true }
  validates :maximum_health, numericality: { greater_than: 0, only_integer: true }
  validates :name, presence: true,
                   length:   { in: MINIMUM_NAME_LENGTH..MAXIMUM_NAME_LENGTH }

  # Returns the hate duration for this monster in seconds.
  # Defaults to 5 minutes if not set in metadata.
  # Limits are applied to ensure reasonable values (30 seconds to 1 hour).
  def hate_duration
    duration = metadata.dig("hate_duration") || 300 # 5 minutes default

    # Apply limits without validation - clamp to reasonable bounds
    [[duration.to_i, 30].max, 3600].min
  end
end

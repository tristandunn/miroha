# frozen_string_literal: true

class Spawn < ApplicationRecord
  belongs_to :base, polymorphic: true
  belongs_to :entity, polymorphic: true, optional: true, dependent: :destroy
  belongs_to :room

  validate :base_cannot_belong_to_room, if: :base, on: :create

  validates :duration, numericality: { allow_nil: true, greater_than: 0, only_integer: true }
  validates :frequency, numericality: { allow_nil: true, greater_than: 0, only_integer: true }

  # Returns the hate duration for this spawn in seconds.
  # Defaults to 5 minutes if not set in metadata.
  # Limits are applied to ensure reasonable values (30 seconds to 1 hour).
  def hate_duration
    duration = metadata.dig("hate_duration") || 300 # 5 minutes default

    # Apply limits without validation - clamp to reasonable bounds
    [[duration.to_i, 30].max, 3600].min
  end

  private

  # Ensure the base does not belong to a room.
  #
  # @return [void]
  def base_cannot_belong_to_room
    if base.room.present?
      errors.add(:base, :room)
    end
  end
end

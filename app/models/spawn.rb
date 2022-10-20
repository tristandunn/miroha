# frozen_string_literal: true

class Spawn < ApplicationRecord
  belongs_to :base, polymorphic: true
  belongs_to :entity, polymorphic: true, optional: true, dependent: :destroy
  belongs_to :room

  validate :base_cannot_belong_to_room, if: :base, on: :create

  validates :duration, numericality: { allow_nil: true, greater_than: 0, only_integer: true }
  validates :frequency, numericality: { allow_nil: true, greater_than: 0, only_integer: true }

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

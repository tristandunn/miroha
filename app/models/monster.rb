# frozen_string_literal: true

class Monster < ApplicationRecord
  include Dispatchable

  MINIMUM_NAME_LENGTH = 3
  MAXIMUM_NAME_LENGTH = 24

  has_one :spawn, foreign_key: :entity_id, inverse_of: :entity, dependent: :nullify

  belongs_to :room, optional: true

  validates :current_health, numericality: {
    less_than_or_equal_to: :maximum_health, greater_than: 0, only_integer: true
  }
  validates :experience, presence:     true,
                         numericality: { greater_than: 0, only_integer: true }
  validates :maximum_health, numericality: { greater_than: 0, only_integer: true }
  validates :name, presence: true,
                   length:   { in: MINIMUM_NAME_LENGTH..MAXIMUM_NAME_LENGTH }
end

# frozen_string_literal: true

class Monster < ApplicationRecord
  MINIMUM_NAME_LENGTH = 3
  MAXIMUM_NAME_LENGTH = 24

  has_one :spawn, foreign_key: :entity_id, inverse_of: :entity, dependent: :nullify

  belongs_to :room, optional: true

  validates :current_health, presence:     true,
                             numericality: { greater_than: 0, only_integer: true }
  validates :experience, presence:     true,
                         numericality: { greater_than: 0, only_integer: true }
  validates :maximum_health, presence:     true,
                             numericality: { greater_than: 0, only_integer: true }
  validates :name, presence: true,
                   length:   { in: MINIMUM_NAME_LENGTH..MAXIMUM_NAME_LENGTH }
end

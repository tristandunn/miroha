# frozen_string_literal: true

class Monster < ApplicationRecord
  MINIMUM_NAME_LENGTH = 3
  MAXIMUM_NAME_LENGTH = 24

  has_one :spawn, foreign_key: :entity_id, inverse_of: :entity, dependent: :nullify

  validates :name, presence: true,
                   length:   { in: MINIMUM_NAME_LENGTH..MAXIMUM_NAME_LENGTH }
end
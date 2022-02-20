# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :characters, dependent: :restrict_with_exception
  has_many :monsters, dependent: :destroy

  validates :description, presence: true
  validates :x, numericality: { only_integer: true },
                uniqueness:   { scope: %i(y z) }
  validates :y, numericality: { only_integer: true }
  validates :z, numericality: { only_integer: true }
end

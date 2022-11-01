# frozen_string_literal: true

class Room < ApplicationRecord
  DEFAULT_COORDINATES = { x: 0, y: 0, z: 0 }.freeze

  has_many :characters, dependent: :restrict_with_exception
  has_many :spawns, dependent: :destroy
  has_many :monsters, dependent: :destroy

  validates :description, presence: true
  validates :x, numericality: { only_integer: true },
                uniqueness:   { scope: %i(y z) }
  validates :y, numericality: { only_integer: true }
  validates :z, numericality: { only_integer: true }

  # Returns the default room.
  #
  # @return [Room] The default room.
  def self.default
    find_by(DEFAULT_COORDINATES)
  end
end

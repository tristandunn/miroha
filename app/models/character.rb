# frozen_string_literal: true

class Character < ApplicationRecord
  MINIMUM_NAME_LENGTH = 3
  MAXIMUM_NAME_LENGTH = 12

  belongs_to :account
  belongs_to :room

  validates :experience, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :level, presence:     true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :name, presence:   true,
                   length:     { in: MINIMUM_NAME_LENGTH..MAXIMUM_NAME_LENGTH },
                   uniqueness: { case_sensitive: false }

  # Return an +Experience+ object for the character.
  #
  # @return [Experience]
  def experience
    Experience.new(experience: self[:experience], level: self[:level])
  end
end

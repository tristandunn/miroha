# frozen_string_literal: true

class Character < ApplicationRecord
  MINIMUM_NAME_LENGTH = 3
  MAXIMUM_NAME_LENGTH = 12

  belongs_to :account
  belongs_to :room

  validates :name, presence:   true,
                   length:     { in: MINIMUM_NAME_LENGTH..MAXIMUM_NAME_LENGTH },
                   uniqueness: { case_sensitive: false }
end

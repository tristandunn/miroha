# frozen_string_literal: true

class Account < ApplicationRecord
  CHARACTER_LIMIT = 1
  EMAIL_MATCHER           = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
  MAXIMUM_EMAIL_LENGTH    = 255
  MINIMUM_PASSWORD_LENGTH = 8

  has_secure_password

  has_many :characters, dependent: :destroy

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :email, presence:   true,
                    length:     { maximum: MAXIMUM_EMAIL_LENGTH },
                    format:     { with: EMAIL_MATCHER },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: MINIMUM_PASSWORD_LENGTH, allow_blank: true }

  # Determine if an account can create a character.
  #
  # @return [Boolean]
  def can_create_character?
    characters.size < CHARACTER_LIMIT
  end
end

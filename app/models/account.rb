# frozen_string_literal: true

class Account < ApplicationRecord
  CHARACTER_LIMIT = 1
  DEFAULT_ALIASES = {
    "/a"  => "/attack",
    "/d"  => "/direct",
    "/me" => "/emote",
    "d"   => "/move down",
    "e"   => "/move east",
    "n"   => "/move north",
    "s"   => "/move south",
    "u"   => "/move up",
    "w"   => "/move west"
  }.freeze
  EMAIL_MATCHER           = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
  MAXIMUM_EMAIL_LENGTH    = 255
  MINIMUM_PASSWORD_LENGTH = 8

  attr_reader :password

  has_many :characters, dependent: :destroy

  validates :email, presence:   true,
                    length:     { maximum: MAXIMUM_EMAIL_LENGTH },
                    format:     { with: EMAIL_MATCHER },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true,
                       length:   { minimum: MINIMUM_PASSWORD_LENGTH },
                       if:       :password_required?

  before_validation :format_attributes
  before_create     :assign_default_aliases

  # Determine if an account can create a character.
  #
  # @return [Boolean]
  def can_create_character?
    characters.size < CHARACTER_LIMIT
  end

  # Assign the provided password and create a digest when present.
  #
  # @return [void]
  def password=(password)
    @password = password

    self.password_digest = if password.present?
                             BCrypt::Password.create(password)
                           end
  end

  protected

  # Assign the default aliases.
  #
  # @return [avoid]
  def assign_default_aliases
    self.aliases = DEFAULT_ALIASES
  end

  # Format attributes to be consistent.
  #
  # * Lowercase and strip the e-mail address.
  #
  # @return [void]
  def format_attributes
    self.email = email.to_s.strip.downcase
  end

  # If the password digest is missing or a new password is present then the
  # password requires validation.
  #
  # @return [Boolean]
  def password_required?
    password_digest.blank? || password.present?
  end
end

# frozen_string_literal: true

class Character < ApplicationRecord
  ACTIVE_DURATION     = 15.minutes
  MINIMUM_NAME_LENGTH = 3
  MAXIMUM_NAME_LENGTH = 12
  SELECTED_KEY        = "character:%s:selected"

  belongs_to :account
  belongs_to :room

  validates :experience, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :level, presence:     true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :name, presence:   true,
                   length:     { in: MINIMUM_NAME_LENGTH..MAXIMUM_NAME_LENGTH },
                   uniqueness: { case_sensitive: false }

  # Return a scope limiting to characters active within +ACTIVE_DURATION+.
  #
  # @return [ActiveRecord::Relation]
  def self.active
    where("active_at >= NOW() - INTERVAL '#{ACTIVE_DURATION}'")
  end

  # Return a scope limiting to characters inactive outside +ACTIVE_DURATION+.
  #
  # @return [ActiveRecord::Relation]
  def self.inactive
    where("active_at < NOW() - INTERVAL '#{ACTIVE_DURATION}'")
  end

  # Return a scope limiting to playing characters.
  #
  # @return [ActiveRecord::Relation]
  def self.playing
    where(playing: true)
  end

  # Return an +Experience+ object for the character.
  #
  # @return [Experience]
  def experience
    Experience.new(current: self[:experience], level: self[:level])
  end

  # Return a +HitPoints+ object for the character's health.
  #
  # @return [HitPoints]
  def health
    HitPoints.new(current: current_health, maximum: maximum_health)
  end

  # Return if the character is inactive.
  #
  # @return [Boolean]
  def inactive?
    active_at < ACTIVE_DURATION.ago
  end

  # Return if the character was recently selected.
  #
  # @return [Boolean]
  def recent?
    Rails.cache.exist?(SELECTED_KEY % id)
  end
end

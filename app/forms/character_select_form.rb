# frozen_string_literal: true

class CharacterSelectForm < BaseForm
  LIMIT_DURATION = 5.minutes

  attr_accessor :account, :id

  validate :ensure_character_is_valid

  # Attempt to find the character for the account by ID.
  #
  # @return [Character|nil]
  def character
    if id.present?
      @character ||= account.characters.find_by(id: id.to_i)
    end
  end

  protected

  # Mark the character as recently selected.
  #
  # @return [void]
  def mark_character_as_recently_selected
    Rails.cache.write(
      Character::SELECTED_KEY % id,
      LIMIT_DURATION.from_now,
      expires_in: LIMIT_DURATION
    )
  end

  # Ensure the character is present and isn't being repeatedly selected,
  # otherwise mark it as recently selected.
  #
  # @return [void]
  def ensure_character_is_valid
    if character.nil?
      errors.add(:base, :character_missing)
    elsif character.recent?
      errors.add(:base, :character_recent)
    else
      mark_character_as_recently_selected
    end
  end
end

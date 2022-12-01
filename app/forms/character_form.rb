# frozen_string_literal: true

class CharacterForm < BaseForm
  attr_accessor :account, :name

  # Attempt to save the character if it's valid.
  #
  # @return [Boolean]
  def save
    if valid?
      character.save
    end
  end

  # Build a new character.
  #
  # @return [Character]
  def character
    @character ||= account.characters.build(attributes)
  end

  private

  # Return the character attributes.
  #
  # @return [Hash]
  def attributes
    {
      name:    name,
      playing: true,
      room:    default_room
    }
  end

  # Return the default room.
  #
  # @return [Room]
  def default_room
    Room.first
  end

  # Validate the character, merging character errors into the form errors.
  #
  # @return [Boolean]
  def valid?(context = nil)
    character.valid?(context).tap do
      errors.merge!(character.errors)
    end
  end
end

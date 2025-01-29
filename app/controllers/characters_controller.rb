# frozen_string_literal: true

class CharactersController < ApplicationController
  before_action :authenticate
  before_action :ensure_account_can_create_character, only: %i(new create)

  # Display the character list.
  def index
    @characters = current_account.characters
  end

  # Render the new character form.
  def new
    @form = CharacterForm.new
  end

  # Create a new character.
  def create
    @form = CharacterForm.new(character_parameters)

    if @form.save
      self.current_character = @form.character

      redirect_to root_url
    else
      render :new
    end
  end

  # Select a character.
  def select
    form = CharacterSelectForm.new(account: current_account, id: params[:id])

    if form.valid?
      enter_game(form.character)

      redirect_to root_url
    else
      redirect_to characters_url, flash: { warning: form.errors[:base].first }
    end
  end

  # Removes a character from the game.
  def exit
    exit_game(current_character)

    redirect_to characters_url
  end

  protected

  # Broadcast character entering the game message to the room.
  #
  # @param [Character] character The character entering the game.
  # @return [void]
  def broadcast_game_entrance_to_room(character)
    Turbo::StreamsChannel.broadcast_render_later_to(
      character.room,
      partial: "characters/enter",
      locals:  { character: character }
    )
  end

  # Broadcast character exiting the game message to the room.
  #
  # @param [Character] character The character exiting the game.
  # @return [void]
  def broadcast_game_exit_to_room(character)
    Turbo::StreamsChannel.broadcast_render_later_to(
      character.room,
      partial: "characters/exit",
      locals:  { character: character }
    )
  end

  # Return the permitted parameters from the required character form parameter.
  #
  # @return [ActionController::Parameters]
  def character_parameters
    params
      .expect(character_form: [:name])
      .merge(account: current_account)
  end

  # Redirect to the character list unless the account can create a character.
  #
  # @return [void]
  def ensure_account_can_create_character
    unless current_account.can_create_character?
      redirect_to characters_url
    end
  end

  # Enter a character into the game.
  #
  # Updates the character as being active, sets them as the current character,
  # and broadcasts their entrance.
  #
  # @param [Character] character The character entering the game.
  # @return [void]
  def enter_game(character)
    character.update(active_at: Time.current, playing: true)

    self.current_character = character

    broadcast_game_entrance_to_room(character)
  end

  # Exit a character into the game.
  #
  # Updates the character as being inactive, clears the current character, and
  # broadcasts their exit.
  #
  # @param [Character] character The character entering the game.
  # @return [void]
  def exit_game(character)
    character.update(playing: false)

    self.current_character = nil

    broadcast_game_exit_to_room(character)
  end
end

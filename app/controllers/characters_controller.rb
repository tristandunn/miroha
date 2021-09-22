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
    character = current_account.characters.find_by(id: params[:id])

    if character.present?
      self.current_character = character

      broadcast_game_entrance_to_room(character)

      redirect_to root_url
    else
      redirect_to characters_url
    end
  end

  # Removes a character from the game.
  def exit
    broadcast_game_exit_to_room(current_character)

    self.current_character = nil

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
      .require(:character_form)
      .permit(:name)
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
end

# frozen_string_literal: true

class GameController < ApplicationController
  layout "game"

  before_action :require_active_character

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to characters_url
  end

  # Render the game.
  def index
    @character = current_character
  end

  protected

  # Override the character from session helper to include other records.
  #
  # @return [Character]
  def character_from_session
    if session[:character_id].present?
      Character
        .includes(:account, room: %i(items monsters))
        .find(session[:character_id])
    end
  end
end

# frozen_string_literal: true

class GameController < ApplicationController
  layout "game"

  before_action :require_active_character

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to characters_url
  end

  # Render the game.
  def index
    @account   = current_account
    @character = current_character
  end

  protected

  # Override the current character helper to include other records.
  #
  # @return [Character]
  def current_character
    @current_character ||= Character.includes(:room).find(session[:character_id])
  end
end

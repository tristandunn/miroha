# frozen_string_literal: true

class GameController < ApplicationController
  layout "game"

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to characters_url
  end

  # Render the game.
  def index
    @character = Character.includes(:room).find(session[:character_id])
  end
end

# frozen_string_literal: true

class PagesController < ApplicationController
  # Render the homepage, or the game if a character is present.
  def index
    if current_character?
      render "game/index", layout: "game"
    end
  end
end

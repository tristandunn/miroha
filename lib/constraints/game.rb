# frozen_string_literal: true

module Constraints
  class Game
    # Determine if the request has access to the game.
    #
    # @return [Boolean]
    def self.matches?(request)
      request.session[:character_id].present?
    end
  end
end

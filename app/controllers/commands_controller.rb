# frozen_string_literal: true

class CommandsController < ApplicationController
  before_action :authenticate
  before_action :require_character
  after_action :mark_character_as_active

  rescue_from ActionController::ParameterMissing do
    head :no_content
  end

  # Execute a user command.
  def create
    command = Command.call(input, character: current_character)

    if command.rendered?
      render command.render_options
    else
      head :no_content
    end
  end

  private

  # Return the command input.
  #
  # @return [String]
  def input
    params.require(:input)
  end

  # Update the character as being active.
  #
  # @return [void]
  def mark_character_as_active
    current_character.update(active_at: Time.current)
  end
end

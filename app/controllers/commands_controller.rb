# frozen_string_literal: true

class CommandsController < ApplicationController
  before_action :require_active_character
  after_action :mark_character_as_active, if: :mark_character_as_active?

  rescue_from ActionController::ParameterMissing do
    head :no_content
  end

  # Execute a user command.
  def create
    command = Command.call(input.squish, character: current_character)

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
    current_character.touch(:active_at) # rubocop:disable Rails/SkipsModelValidations
  end

  # Determine if it's time to mark a character as active.
  #
  # @return [Boolean]
  def mark_character_as_active?
    current_character.active_at <= 30.seconds.ago
  end
end

# frozen_string_literal: true

class CommandsController < ApplicationController
  before_action :require_active_character, :rate_limit_command
  after_action :mark_character_as_active, if: :mark_character_as_active?

  rescue_from ActionController::ParameterMissing do
    head :no_content
  end

  # Execute a user command.
  def create
    if command.rendered?
      render command.render_options
    else
      head :no_content
    end
  end

  private

  # Return an instance of the command being created.
  #
  # @return [Commands::Base] The command being created.
  def command
    @command ||= Command.call(input.squish, character: current_character)
  end

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

  # Run rate limiting for the command being created.
  #
  # @return [void]
  def rate_limit_command
    rate_limiting(
      to:     command.class.limit,
      within: command.class.period,
      with:   -> { head :too_many_requests },
      store:  cache_store,
      by:     -> { rate_limit_identifier }
    )
  end

  # Return the rate limit identifier for the command being created.
  #
  # @return [String]
  def rate_limit_identifier
    [
      "account-#{current_character.account_id}",
      "command-#{command.class.name.delete_prefix("Commands::").underscore}"
    ].join(":")
  end
end

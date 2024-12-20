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
  # @return [Commands::Base] Instance of the command being created.
  def command
    @command ||= command_class.new(input, character: current_character).tap(&:call)
  end

  # Return the class of the command being created.
  #
  # @return [Class] Class of command being created.
  def command_class
    @command_class ||= Command::Parser.call(input)
  end

  # Return the command input.
  #
  # @return [String]
  def input
    params.require(:input).squish
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
      to:     command_class.limit,
      within: command_class.period,
      with:   -> { head :too_many_requests },
      store:  cache_store,
      by:     -> { rate_limit_scope },
      name:   rate_limit_name
    )
  end

  # Return the name of the rate limiter, based on account ID.
  #
  # @return [String]
  def rate_limit_name
    "account-#{current_character.account_id}"
  end

  # Return the scope for the rate limit based on the command class name.
  #
  # @return [String]
  def rate_limit_scope
    command_class.name.delete_prefix("Commands::").underscore
  end
end

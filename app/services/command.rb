# frozen_string_literal: true

class Command
  DEFAULT = "say"
  MATCHER = %r{^/([a-z]+)(?=\s|$)}i
  SLASH   = "/"

  # Initialize a command.
  #
  # @param [String] input The raw command input.
  # @param [Character] character The character running the command.
  def initialize(input, character:)
    @character = character
    @input     = input.squish
  end

  # Create an instance and call +#call+.
  # @param [String] input The raw command input.
  # @param [Character] character The character running the command.
  # @return [Command] The command instance.
  def self.call(input, character:)
    new(input, character: character).call
  end

  # Call the command.
  #
  # @return [Command] The command instance.
  def call
    instance = command.new(input, character: character)
    instance.call
    instance
  end

  private

  attr_reader :character, :input

  # Determine the command name.
  #
  # @return [String] The parsed command name.
  def name
    if input.starts_with?(SLASH)
      input.match(MATCHER)[1]
    else
      DEFAULT
    end
  end

  # Return the command class.
  #
  # @return [Class] The command class.
  def command
    "commands/#{name}_command".camelize.constantize
  rescue NameError
    Commands::UnknownCommand
  end
end

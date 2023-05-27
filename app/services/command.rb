# frozen_string_literal: true

class Command
  DEFAULT_NAME = "say"
  MATCHER      = %r{^/([a-z]+)(?=\s|$)}i

  # Parse the command, create an instance, and call +#call+.
  #
  # @param [String] input The raw command input.
  # @param [Character] character The character running the command.
  # @return [Command] The command instance.
  def self.call(input, character:)
    command  = parse(input)
    instance = command.new(input, character: character)
    instance.tap(&:call)
  end

  # Convert a command to a command class.
  #
  # @param [String] input The raw command input.
  # @return [Commands::Base] The command class.
  def self.parse(input)
    name = input.match(MATCHER)&.captures&.first || DEFAULT_NAME

    "commands/#{name}".camelize.constantize
  rescue NameError
    Commands::Unknown
  end
end

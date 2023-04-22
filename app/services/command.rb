# frozen_string_literal: true

class Command
  DEFAULT_ALIASES = {
    "/a"  => "/attack",
    "/d"  => "/direct",
    "/me" => "/emote",
    "d"   => "/move down",
    "e"   => "/move east",
    "n"   => "/move north",
    "s"   => "/move south",
    "u"   => "/move up",
    "w"   => "/move west"
  }.freeze

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

  # Determine the throttle limit for the provided command.
  #
  # @param [String] input The raw command input.
  # @return [Integer] The throttle limit for the parsed command.
  def self.limit(input)
    command = parse(input)
    command.const_get(:THROTTLE_LIMIT)
  end

  # Convert a command to a command class.
  #
  # @param [String] input The raw command input.
  # @return [Commands::Base] The command class.
  def self.parse(input)
    name = input.match(MATCHER)&.captures&.first || DEFAULT_NAME

    "commands/#{name}_command".camelize.constantize
  rescue NameError
    Commands::UnknownCommand
  end

  # Determine the throttle period for the provided command.
  #
  # @param [String] input The raw command input.
  # @return [Integer] The throttle period for the parsed command.
  def self.period(input)
    command = parse(input)
    command.const_get(:THROTTLE_PERIOD)
  end
end

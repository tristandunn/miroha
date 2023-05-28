# frozen_string_literal: true

class Command
  # Parse the command, create an instance, and call +#call+.
  #
  # @param [String] input The raw command input.
  # @param [Character] character The character running the command.
  # @return [Command] The command instance.
  def self.call(input, character:)
    command  = Parser.call(input)
    instance = command.new(input, character: character)
    instance.tap(&:call)
  end
end

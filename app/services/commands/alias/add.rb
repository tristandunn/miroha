# frozen_string_literal: true

module Commands
  module Alias
    class Add < Base
      argument shortcut: 0
      argument command:  (1..)

      # Determine if the argument matches this command.
      #
      # @return [Boolean]
      def self.match?(arguments)
        arguments.first == I18n.t("commands.lookup.alias.arguments.add")
      end

      private

      # Returns the command, ensuring a forward slash is present.
      #
      # @return [String]
      def command
        value = parameters[:command]

        unless value.start_with?("/")
          value = "/#{value}"
        end

        value
      end

      # Return the handler for a successful command execution.
      #
      # @return [Success]
      def success
        Success.new(character: character, command: command, shortcut: parameters[:shortcut])
      end

      # Validate if the command is valid.
      #
      # @return [Boolean] If the alias exists or not.
      def validate_command
        parsed = Command::Parser.call(command)

        if parsed == Commands::Unknown
          InvalidCommand.new(command: command)
        end
      end
    end
  end
end

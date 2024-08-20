# frozen_string_literal: true

module Commands
  class Help < Base
    class Command < Result
      locals :commands

      # Initialize a help command result.
      #
      # @return [void]
      def initialize(name:)
        @name = name
      end

      private

      attr_reader :name

      # Return help for the single command.
      #
      # @return [Array]
      def command
        [I18n.t(key).merge(name: name)]
      end

      # Return help for the subcommands or the command itself.
      #
      # @return [Array]
      def commands
        subcommands || command
      end

      # Return the I18n key for the command name.
      #
      # @return [String]
      def key
        "commands.help.commands.#{name}"
      end

      # Return the help list partial path.
      #
      # @return [String]
      def partial
        "commands/help/list"
      end

      # Return help for the subcommands, if any.
      #
      # @return [Array] When subcommands exist.
      # @return [nil] When subcommands do not exist.
      def subcommands
        if I18n.exists?("#{key}.subcommands")
          I18n
            .t("#{key}.subcommands")
            .each.with_object([]) do |(subcommand, details), result|
              result << details.merge(
                arguments: "#{subcommand} #{details[:arguments]}".strip,
                name:      name
              )
            end
        end
      end
    end
  end
end

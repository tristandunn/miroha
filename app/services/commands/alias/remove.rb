# frozen_string_literal: true

module Commands
  module Alias
    class Remove < Base
      argument name: 0

      # Determine if the argument matches this command.
      #
      # @return [Boolean]
      def self.match?(arguments)
        arguments.first == I18n.t("commands.lookup.alias.arguments.remove")
      end

      private

      # Return the handler for a successful command execution.
      #
      # @return [Success]
      def success
        Success.new(character: character, name: parameters[:name])
      end

      # Validate if the alias name exists.
      #
      # @return [Boolean] If the alias exists or not.
      def validate_name
        unless character.account.aliases.key?(parameters[:name])
          UnknownAlias.new(name: parameters[:name])
        end
      end
    end
  end
end

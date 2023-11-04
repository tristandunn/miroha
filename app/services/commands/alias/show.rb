# frozen_string_literal: true

module Commands
  module Alias
    class Show < Base
      argument alias_name: 2

      # Determine if the argument matches this command.
      #
      # @return [Boolean]
      def self.match?(arguments)
        arguments.first == "show"
      end

      private

      # Return the requested alias to show.
      #
      # @return [Hash]
      def aliases
        character.account.aliases.slice(parameters[:alias_name])
      end

      # Return the handler for a successful command execution.
      #
      # @return [Success]
      def success
        Success.new(aliases: aliases)
      end

      # Validate if the alias name exists.
      #
      # @return [Boolean] If the alias exists or not.
      def validate_alias_name
        if aliases.blank?
          UnknownAlias.new(name: parameters[:alias_name])
        end
      end
    end
  end
end

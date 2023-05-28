# frozen_string_literal: true

module Commands
  module Alias
    class List < Base
      # Return if the arguments match the command.
      #
      # @return [Boolean]
      def self.match?(arguments)
        arguments.empty?
      end

      # Determine if the command is rendered immediately.
      #
      # @return [Boolean]
      def rendered?
        true
      end

      private

      # Return the locals for the partial template.
      #
      # @return [Hash] The local variables.
      def locals
        {
          aliases: character.account.aliases
        }
      end
    end
  end
end

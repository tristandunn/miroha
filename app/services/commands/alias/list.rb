# frozen_string_literal: true

module Commands
  module Alias
    class List < Base
      # Determine if the argument matches this command.
      #
      # @return [Boolean]
      def self.match?(arguments)
        arguments.empty? || arguments.first == "list"
      end

      # Return the handler for a successful command execution.
      #
      # @return [List]
      def success
        Success.new(character: character)
      end
    end
  end
end

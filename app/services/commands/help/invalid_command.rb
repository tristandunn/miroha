# frozen_string_literal: true

module Commands
  class Help < Base
    class InvalidCommand < Result
      locals :name

      # Initialize a help invalid command result.
      #
      # @return [void]
      def initialize(name:)
        @name = name
      end
    end
  end
end

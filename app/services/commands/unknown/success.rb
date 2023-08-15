# frozen_string_literal: true

module Commands
  class Unknown < Base
    class Success < Result
      locals :command

      # Initialize a successful unknown result.
      #
      # @return [void]
      def initialize(command:)
        @command = command
      end
    end
  end
end

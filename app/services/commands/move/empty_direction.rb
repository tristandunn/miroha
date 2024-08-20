# frozen_string_literal: true

module Commands
  class Move < Base
    class EmptyDirection < Result
      locals :direction

      # Initialize an empty direction move result.
      #
      # @param [String] direction The empty direction.
      # @return [void]
      def initialize(direction:)
        @direction = direction
      end
    end
  end
end

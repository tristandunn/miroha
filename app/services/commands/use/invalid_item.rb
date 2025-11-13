# frozen_string_literal: true

module Commands
  class Use < Base
    class InvalidItem < Result
      locals :name

      # Initialize a use invalid item result.
      #
      # @param [String] name The name of the invalid item.
      # @return [void]
      def initialize(name:)
        @name = name
      end
    end
  end
end

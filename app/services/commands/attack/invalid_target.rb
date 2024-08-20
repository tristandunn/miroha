# frozen_string_literal: true

module Commands
  class Attack < Base
    class InvalidTarget < Result
      locals :target_name

      # Initialize an attack invalid target result.
      #
      # @param [String] target_name The name of the invalid target.
      # @return [void]
      def initialize(target_name:)
        @target_name = target_name
      end
    end
  end
end

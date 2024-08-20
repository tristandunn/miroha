# frozen_string_literal: true

module Commands
  class Direct < Base
    class MissingTarget < Result
      locals :target_name

      # Initialize a missing target direct message result.
      #
      # @param [String] target_name The missing target name.
      # @return [void]
      def initialize(target_name:)
        @target_name = target_name
      end
    end
  end
end

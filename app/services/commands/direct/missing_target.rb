# frozen_string_literal: true

module Commands
  class Direct < Base
    class MissingTarget < Result
      locals :target_name

      # Initialize a missing target direct message result.
      #
      # @return [void]
      def initialize(target_name:)
        @target_name = target_name
      end
    end
  end
end

# frozen_string_literal: true

module Commands
  class Direct < Base
    class MissingMessage < Result
      # Determine if the result is rendered immediately.
      #
      # @return [Boolean]
      def rendered?
        false
      end
    end
  end
end

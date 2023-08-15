# frozen_string_literal: true

module Commands
  class Whisper < Base
    class MissingTarget < Result
      locals :target

      # Initialize a missing target whisper result.
      #
      # @return [void]
      def initialize(target:)
        @target = target
      end
    end
  end
end

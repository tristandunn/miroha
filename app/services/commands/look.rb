# frozen_string_literal: true

module Commands
  class Look < Base
    argument object: 0

    private

    # Return the handler for a successful command execution.
    #
    # @return [Success]
    def success
      Success.new(
        character: character,
        object:    parameters[:object]
      )
    end
  end
end

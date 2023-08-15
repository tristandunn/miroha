# frozen_string_literal: true

module Commands
  class Alias < Base
    # Return the handler for a successful command execution.
    #
    # @return [List]
    def success
      List.new(character: character)
    end
  end
end

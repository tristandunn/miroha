# frozen_string_literal: true

module Commands
  class Unknown < Base
    private

    # Return the handler for a successful command execution.
    #
    # @return [Success]
    def success
      Success.new(command: input)
    end
  end
end

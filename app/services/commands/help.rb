# frozen_string_literal: true

module Commands
  class Help < Base
    private

    # Return the handler for a successful command execution.
    #
    # @return [Success]
    def success
      Success.new
    end
  end
end

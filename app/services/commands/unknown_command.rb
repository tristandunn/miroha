# frozen_string_literal: true

module Commands
  class UnknownCommand < Base
    # Determine if the command is rendered immediately.
    #
    # @return [Boolean]
    def rendered?
      true
    end

    private

    # Return the locals for the partial template.
    #
    # @return [Hash] The local variables.
    def locals
      {
        command: input
      }
    end
  end
end

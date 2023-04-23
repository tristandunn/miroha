# frozen_string_literal: true

module Commands
  class AliasCommand < Base
    # Determine if the command is rendered immediately.
    #
    # @return [Boolean]
    def rendered?
      true
    end

    private

    # Return the command aliases.
    #
    # @return [Hash] A hash of alias to command mappings.
    def aliases
      Command::DEFAULT_ALIASES
    end

    # Return the locals for the partial template.
    #
    # @return [Hash] The local variables.
    def locals
      {
        aliases: aliases
      }
    end
  end
end

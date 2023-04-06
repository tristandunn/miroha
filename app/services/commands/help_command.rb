# frozen_string_literal: true

module Commands
  class HelpCommand < Base
    # Return help data for each command.
    #
    # @return [Array] An array of command help hashes.
    def self.commands
      @commands ||= I18n
                    .t("commands.help.commands")
                    .each.with_object([]) do |(name, details), result|
                      result << details.merge(name: name.to_s)
                    end
    end

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
        commands: self.class.commands
      }
    end
  end
end

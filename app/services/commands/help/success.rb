# frozen_string_literal: true

module Commands
  class Help < Base
    class Success < Result
      locals :commands

      delegate :commands, to: :class

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
    end
  end
end

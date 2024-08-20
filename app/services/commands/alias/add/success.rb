# frozen_string_literal: true

module Commands
  module Alias
    class Add < Base
      class Success < Result
        locals :account, :command, :shortcut

        # Initialize an alias add success result.
        #
        # @param [Character] character The character adding the alias.
        # @param [String] command The command name.
        # @param [String] shortcut The shortcut string.
        # @return [void]
        def initialize(character:, command:, shortcut:)
          @character = character
          @command   = command
          @shortcut  = shortcut
        end

        # Add the alias to the character's account.
        #
        # @return [void]
        def call
          account.update!(aliases: account.aliases.merge(shortcut => command))
        end

        private

        attr_reader :character, :command, :shortcut

        delegate :account, to: :character
      end
    end
  end
end

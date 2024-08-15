# frozen_string_literal: true

module Commands
  module Alias
    class Remove < Base
      class Success < Result
        locals :name

        # Initialize a successful alias remove result.
        #
        # @return [void]
        def initialize(character:, name:)
          @character = character
          @name      = name
        end

        # Remove the alias from the character's account.
        #
        # @return [void]
        def call
          account.update!(aliases: account.aliases.except(name))
        end

        private

        attr_reader :character, :name

        delegate :account, to: :character
      end
    end
  end
end

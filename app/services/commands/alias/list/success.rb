# frozen_string_literal: true

module Commands
  module Alias
    class List < Base
      class Success < Result
        locals :aliases

        delegate :account, to: :character, private: true
        delegate :aliases, to: :account, private: true

        # Initialize an alias list result.
        #
        # @param [Character] character The character listing the aliases.
        # @return [void]
        def initialize(character:)
          @character = character
        end

        private

        attr_reader :character
      end
    end
  end
end

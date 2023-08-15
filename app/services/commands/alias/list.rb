# frozen_string_literal: true

module Commands
  class Alias < Base
    class List < Result
      locals :aliases

      delegate :account, to: :character, private: true
      delegate :aliases, to: :account, private: true

      # Initialize an alias list result.
      #
      # @return [void]
      def initialize(character:)
        @character = character
      end

      private

      attr_reader :character
    end
  end
end

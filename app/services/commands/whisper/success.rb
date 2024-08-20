# frozen_string_literal: true

module Commands
  class Whisper < Base
    class Success < Result
      locals :character, :message, :target

      # Initialize a successful whisper result.
      #
      # @param [Character] character The character whispering.
      # @param [String] message The message being whispered.
      # @param [Character] target The target being whispered to.
      # @return [void]
      def initialize(character:, message:, target:)
        @character = character
        @message   = message
        @target    = target
      end

      # Broadcast the whisper to the target.
      #
      # @return [void]
      def call
        broadcast_message
      end

      private

      # Broadcast the whisper to the target.
      #
      # @return [void]
      def broadcast_message
        broadcast_append_later_to(
          target,
          target: "messages",
          locals: { character: character, message: message }
        )
      end
    end
  end
end

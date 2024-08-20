# frozen_string_literal: true

module Commands
  class Emote < Base
    class Success < Result
      DEFAULT_PUNCTUATION    = "."
      PUNCTUATION_CHARACTERS = %w(. ? ! " …).freeze
      PUNCTUATION_MATCHER    = /[#{PUNCTUATION_CHARACTERS.join}]\z/

      locals :character, :message, :punctuation

      # Initialize a successful emote result.
      #
      # @param [Character] character The character emoting.
      # @param [String] message The message being emoted.
      # @return [void]
      def initialize(character:, message:)
        @character = character
        @message   = message
      end

      # Broadcast the message to the room.
      #
      # @return [void]
      def call
        broadcast_append_later_to(character.room_gid, target: "messages")
      end

      # Return the default punctuation if no punctuation is in the message.
      #
      # @return [String] The default punctuation if needed.
      # @return [nil] If no punctuation is needed.
      def punctuation
        return if PUNCTUATION_MATCHER.match?(@message)

        DEFAULT_PUNCTUATION
      end

      # Determine if the result is rendered immediately.
      #
      # @return [Boolean]
      def rendered?
        false
      end
    end
  end
end

# frozen_string_literal: true

module Commands
  class Say < Base
    class Success < Result
      locals :character, :message

      # Initialize a successful say result.
      #
      # @return [void]
      def initialize(character:, message:)
        @character = character
        @message   = message
      end

      # Broadcast the message to the room.
      #
      # @return [void]
      def call
        broadcast_message
      end

      # Determine if the result is rendered immediately.
      #
      # @return [Boolean]
      def rendered?
        false
      end

      private

      # Broadcast the message to the character's room.
      #
      # @return [void]
      def broadcast_message
        broadcast_append_later_to(character.room_gid, target: "messages")
      end
    end
  end
end

# frozen_string_literal: true

module Commands
  class Direct < Base
    class Success < Result
      locals :character, :message, :target

      # Initialize a successful direct message result.
      #
      # @param [Character] character The character messaging the target.
      # @param [String] message The message being directed to the target.
      # @param [Character] target The target being messaged.
      # @return [void]
      def initialize(character:, message:, target:)
        @character = character
        @message   = message
        @target    = target
      end

      # Broadcast the direct message to the target.
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

      # Broadcast the direct message to the target.
      #
      # @return [void]
      def broadcast_message
        broadcast_append_later_to(character.room_gid, target: "messages")
      end
    end
  end
end

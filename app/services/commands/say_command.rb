# frozen_string_literal: true

module Commands
  class SayCommand < Base
    # Broadcast a say command to chat.
    def call
      if valid?
        broadcast_append_later_to(character.room_gid, target: "messages")
      end
    end

    private

    alias message input_without_command

    # Return the locals for the partial template.
    #
    # @return [Hash] The local variables.
    def locals
      {
        character: character,
        message:   message
      }
    end

    # Determine if the command is valid based on input presence.
    #
    # @return [Boolean]
    def valid?
      message.present?
    end
  end
end

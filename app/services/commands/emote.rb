# frozen_string_literal: true

module Commands
  class Emote < Base
    DEFAULT_PUNCTUATION    = "."
    PUNCTUATION_CHARACTERS = %w(. ? ! " …).freeze
    PUNCTUATION_MATCHER    = /[#{PUNCTUATION_CHARACTERS.join}]\z/

    # Broadcast an emote command to chat.
    def call
      if valid?
        broadcast_append_later_to(character.room_gid, target: "messages")
      end
    end

    private

    # Return the locals for the partial template.
    #
    # @return [Hash] The local variables.
    def locals
      {
        message: message
      }
    end

    # Return the message with the character's name as a prefix and a period
    # suffix if there's no existing punctuation.
    #
    # @return [String]
    def message
      action = input_without_command
      action << DEFAULT_PUNCTUATION unless PUNCTUATION_MATCHER.match?(action)

      "#{character.name} #{action}"
    end

    # Determine if the command is valid based on input presence.
    #
    # @return [Boolean]
    def valid?
      input_without_command.present?
    end
  end
end

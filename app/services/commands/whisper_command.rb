# frozen_string_literal: true

module Commands
  class WhisperCommand < Base
    # Broadcast a whisper command to the target.
    def call
      if valid?
        broadcast_append_later_to(target, target: "messages")
      end
    end

    # Return the locals for the partial template.
    #
    # @return [Hash] The local variables.
    def locals
      {
        character:   character,
        message:     message,
        target:      target,
        target_name: target_name
      }
    end

    # Determine if the command is rendered immediately.
    #
    # @return [Boolean]
    def rendered?
      true
    end

    private

    # Return the message being whispered to the target.
    #
    # @return [String]
    def message
      @message ||= input_without_command.split(" ", 2).second
    end

    # Attempt to find the target by name.
    #
    # @return [Character] If a character is found.
    # @return [nil] If a character is not found.
    def target
      return @target if defined?(@target)

      @target = character.room.characters.active.find_by("LOWER(NAME) = ?", target_name.downcase)
    end

    # Return the name of the target.
    #
    # @return [String]
    def target_name
      input_without_command.split(" ", 2).first
    end

    # Determine if the command is valid based on the input and target.
    #
    # @return [Boolean]
    def valid?
      message.present? &&
        target.present? &&
        target != character
    end
  end
end

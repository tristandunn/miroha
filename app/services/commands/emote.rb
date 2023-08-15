# frozen_string_literal: true

module Commands
  class Emote < Base
    argument message: (0..)

    private

    # Return the handler for a successful command execution.
    #
    # @return [Success]
    def success
      Success.new(character: character, message: parameters[:message])
    end

    # Validate a message is present.
    #
    # @return [MissingMessage] If the message is missing.
    # @return [nil] If the message is present.
    def validate_message
      if parameters[:message].blank?
        MissingMessage.new
      end
    end
  end
end

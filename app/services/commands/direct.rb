# frozen_string_literal: true

module Commands
  class Direct < Base
    argument message: (1..)
    argument target:  0

    private

    # Determine if the target is missing from the room.
    #
    # @return [Boolean]
    def missing_target?
      parameters[:target].blank? || target.nil?
    end

    # Return the handler for a successful command execution.
    #
    # @return [Success]
    def success
      Success.new(
        character: character,
        message:   parameters[:message],
        target:    target
      )
    end

    # Attempt to find the target by name.
    #
    # @return [Character] If a character is found.
    # @return [nil] If a character is not found.
    def target
      return @target if defined?(@target)

      @target = character.room.characters.active
                         .find_by("LOWER(NAME) = ?", parameters[:target].downcase)
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

    # Validate a target is present and valid.
    #
    # @return [MissingTarget] If the target is missing.
    # @return [InvalidTarget] If the target is invalid.
    # @return [nil] If the target is present and valid.
    def validate_target
      if missing_target?
        MissingTarget.new(target_name: parameters[:target])
      elsif target == character
        InvalidTarget.new
      end
    end
  end
end

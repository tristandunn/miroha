# frozen_string_literal: true

module Commands
  class Attack < Base
    THROTTLE_LIMIT  = 1
    THROTTLE_PERIOD = 1

    argument target: 0

    private

    # Return if the target is alive.
    #
    # @return [Boolean]
    def alive?
      target.current_health > damage
    end

    # Return the damage being dealt to the target.
    #
    # @return [Integer]
    def damage
      @damage ||= SecureRandom.random_number(0..1)
    end

    # Return if the target was missed.
    #
    # @return [Boolean]
    def missed?
      damage.zero?
    end

    # Return the handler for a successful command execution. Also damages the
    # target when not missed.
    #
    # @return [Missed] If the target was missed.
    # @return [Hit] If the target was hit and is still alive.
    # @return [Killed] If the target was hit and killed.
    def success
      if missed?
        Missed.new(character: character, target: target)
      elsif alive?
        Hit.new(character: character, damage: damage, target: target)
      else
        Killed.new(character: character, damage: damage, target: target)
      end
    end

    # Attempt to find the target by name.
    #
    # @return [Monster] If a monster is found.
    # @return [nil] If a monster is not found.
    def target
      return @target if defined?(@target)

      @target = character.room.monsters
                         .where("LOWER(NAME) = ?", parameters[:target].downcase)
                         .first
    end

    # Validate a target is present and valid.
    #
    # @return [MissingTarget] If the target is blank.
    # @return [InvalidTarget] If the target is invalid.
    # @return [nil] If the target is valid.
    def validate_target
      if parameters[:target].blank?
        MissingTarget.new
      elsif target.nil?
        InvalidTarget.new(target_name: parameters[:target])
      end
    end
  end
end

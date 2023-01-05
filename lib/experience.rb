# frozen_string_literal: true

class Experience
  attr_reader :current

  # Initialize experience.
  #
  # @param [Integer] current The current experience of the character.
  # @param [Integer] level The current level of the character.
  def initialize(current:, level:)
    @current = current
    @level = level
  end

  delegate :+, to: :current

  # Returns the experience needed for the next level.
  #
  # @return [Integer]
  def needed
    experience_for(level)
  end

  # Returns the experience remaining for the next level.
  #
  # @return [Integer]
  def remaining
    needed - current
  end

  # Returns the experience remaining percentage for the next level.
  #
  # @return [Float]
  def remaining_percentage
    previously_needed = experience_for(level - 1)

    ((current - previously_needed) / (needed - previously_needed).to_f) * 100
  end

  private

  attr_reader :level

  # Returns the experience needed for the provided level.
  #
  # @param [Integer] level The level to calculate the experience for.
  # @return [Integer]
  def experience_for(level)
    ((level**1.5) * 1_000).floor
  end
end

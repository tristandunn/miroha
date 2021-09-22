# frozen_string_literal: true

class Experience
  # Initialize experience.
  #
  # @param [Integer] experience The current experience of the character.
  # @param [Integer] level The current level of the character.
  def initialize(experience:, level:)
    @experience = experience
    @level = level
  end

  # Returns the experience needed for the next level.
  #
  # @return [Integer]
  def needed
    (1_000 * (level**1.5)).floor
  end

  # Returns the experience remaining for the next level.
  #
  # @return [Integer]
  def remaining
    needed - experience
  end

  # Returns the experience remaining percentage for the next level.
  #
  # @return [Float]
  def remaining_percentage
    (experience / needed.to_f) * 100
  end

  private

  attr_reader :experience, :level
end

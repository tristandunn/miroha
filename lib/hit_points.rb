# frozen_string_literal: true

class HitPoints
  attr_reader :current, :maximum

  # Initialize hit points.
  #
  # @param [Integer] current The current hit points of the character.
  # @param [Integer] maximum The maximum hit points of the character.
  def initialize(current:, maximum:)
    @current = current
    @maximum = maximum
  end

  # Returns the hit points remaining percentage.
  #
  # @return [Float]
  def remaining_percentage
    (current / maximum.to_f) * 100
  end
end

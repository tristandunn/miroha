# frozen_string_literal: true

class StateMachine
  attr_accessor :current_state

  # Initialize the state machine.
  #
  # @return [void]
  def initialize
    @current_state = self.class.states.first
  end

  # Add a state to the machine.
  #
  # @return [Array] The names of states for the machine.
  def self.state(*names)
    names.each do |name|
      states << name.to_s
    end
  end

  # Returns the state names for the machine.
  #
  # @return [Array] The names of the states for the machine.
  def self.states
    @states ||= []
  end

  # Return the successors for each state.
  #
  # @return [Hash] The successors for each state.
  def self.successors
    @successors ||= {}
  end

  # Adds a transition between states.
  #
  # @return [void]
  def self.transition(from:, to:)
    from = from.to_s.presence
    to   = Array(to).filter_map { |state| state.to_s.presence }

    if to.present?
      successors[from] ||= []
      successors[from]  += to
    end
  end

  # Transition to a new state.
  #
  # @param [String|Symbol] state The state to transition to.
  # @return [Boolean]
  def transition_to(state)
    if valid_transition?(state)
      self.current_state = state.to_s.presence
    else
      false
    end
  end

  private

  # Return if the provided state is a valid transition for the current state.
  #
  # @param [String|Symbol] state The transition state to validate.
  # @return [Boolean]
  def valid_transition?(state)
    successors = self.class.successors[current_state]
    successors.present? && successors.include?(state.to_s.presence)
  end
end

# frozen_string_literal: true

class StateMachine
  class TransitionFailedError < StandardError
  end

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

  # Returns the stats of the machine.
  #
  # @return [Array] The names of the states for the machine.
  def self.states
    @states ||= []
  end

  # Return the successors for each state.
  #
  # @return [Hash] The state successors.
  def self.successors
    @successors ||= {}
  end

  # Adds a transition between states.
  #
  # @return [void]
  def self.transition(from: nil, to: nil)
    from = from.to_s.presence
    to   = Array(to).filter_map { |state| state.to_s.presence }.compact

    if to.present?
      successors[from] ||= []
      successors[from]  += to
    end
  end

  # Transition to a new state.
  #
  # @return [Boolean]
  def transition_to(state)
    transition_to!(state)
  rescue TransitionFailedError
    false
  end

  # Transition to a new state, raising if it is invalid.
  #
  # @return [Boolean]
  def transition_to!(state)
    if valid_transition?(state)
      self.current_state = state.to_s.presence
    else
      raise TransitionFailedError
    end

    true
  end

  private

  # Validate a transition between states.
  #
  # @return [Boolean]
  def valid_transition?(state)
    self.class.successors[current_state]&.exclude?(state.to_s.presence)
  end
end

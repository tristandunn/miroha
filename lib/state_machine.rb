# frozen_string_literal: true

class StateMachine
  attr_reader :current_state

  # Initialize the state machine.
  #
  # @return [void]
  def initialize
    @current_state = self.class.states.first
  end

  # Returns the callbacks for the machine.
  #
  # @return [Array] The callbacks for the machine.
  def self.callbacks
    @callbacks ||= {
      after: [],
      guard: []
    }
  end

  # Add an after transition callback.
  #
  # @param [String|Symbol] from The from transition name.
  # @param [String|Symbol] to The to transition name.
  # @param [Proc] block The after transition callback.
  # @return [void]
  def self.after_transition(from: nil, to: nil, &block)
    add_callback(from: from, to: to, callback: block, type: :after)
  end

  # Add a guard callback.
  #
  # @param [String|Symbol] from The from transition name.
  # @param [String|Symbol] to The to transition name.
  # @param [Proc] block The guard callback.
  # @return [void]
  def self.guard_transition(from: nil, to: nil, &block)
    add_callback(from: from, to: to, callback: block, type: :guard)
  end

  # Add a state to the machine.
  #
  # @param [Array<String|Symbol>] names The name of states.
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
  # @param [String|Symbol] from The from transition name.
  # @param [String|Symbol] to The to transition name.
  # @return [void]
  def self.transition(from:, to:)
    from = from.to_s.presence
    to   = Array(to).filter_map { |state| state.to_s.presence }

    if to.present?
      successors[from] ||= []
      successors[from] += to
    end
  end

  # Transition to a new state.
  #
  # @param [String|Symbol] state The state to transition to.
  # @return [Boolean]
  def transition_to(state)
    if valid_transition?(state)
      @current_state = state.to_s.presence

      callbacks = self.class.callbacks[:after].select do |callback|
        callback.valid?(to: current_state)
      end

      callbacks.all?(&:call)
    end
  end

  private

  # Add a callback.
  #
  # @param [String|Symbol] from The from transition name.
  # @param [String|Symbol] to The to transition name.
  # @param [Proc] block The guard callback.
  # @param [Symbol] type The type of callback.
  def self.add_callback(callback:, type:, from: nil, to: nil)
    callbacks[type.to_sym] << Callback.new(callback: callback, from: from, to: to)
  end
  private_class_method :add_callback

  # Return if the provided state is a valid transition for the current state
  # and no guards prevent the transition.
  #
  # @param [String|Symbol] state The transition state to validate.
  # @return [Boolean] Whether or not the state is a valid transition.
  def valid_transition?(state)
    successors = self.class.successors[current_state]

    if successors&.include?(state.to_s.presence)
      callbacks = self.class.callbacks[:guard].select { |callback| callback.valid?(from: current_state, to: state) }
      callbacks.all?(&:call)
    else
      false
    end
  end
end

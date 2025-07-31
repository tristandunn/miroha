# frozen_string_literal: true

class StateMachine
  class Callback
    attr_reader :callback, :from, :to

    delegate :call, to: :callback

    # Initialize a callback.
    #
    # @return [void]
    def initialize(callback:, from: nil, to: nil)
      @from     = from.to_s.presence
      @to       = Array(to).map(&:to_s).select(&:presence)
      @callback = callback
    end

    # Determine if the callback applies to the transition.
    #
    # @return [Boolean]
    def valid?(from: nil, to: nil)
      from = from.to_s.presence
      to   = to.to_s.presence

      matches_all? ||
        matches_to?(from, to) ||
        matches_from?(from, to) ||
        matches_both?(from, to)
    end

    private

    # Return if the callback matches all states and transitions.
    #
    # @return [Boolean]
    def matches_all?
      from.nil? && to.blank?
    end

    # Return if the callback matches the from state.
    #
    # @return [Boolean]
    def matches_from?(from, to)
      from == self.from && (to.nil? || self.to.blank?)
    end

    # Return if the callback matches the to transition.
    #
    # @return [Boolean]
    def matches_to?(from, to)
      (from.nil? || self.from.nil?) && self.to.include?(to)
    end

    # Return if the callback matches the from state and to transition.
    #
    # @return [Boolean]
    def matches_both?(from, to)
      from == self.from && self.to.include?(to)
    end
  end
end

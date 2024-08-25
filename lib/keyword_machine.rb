# frozen_string_literal: true

class KeywordMachine < StateMachine
  # Return the successors for each state.
  #
  # @return [Hash] The state successors.
  def self.keywords
    @keywords ||= {}
  end

  # Adds a transition between states.
  #
  # @return [void]
  def self.keyword(name, from: nil, method: nil, to: nil)
    keywords[name] = { from: from, method: method, to: to }.compact
  end

  # Process a keyword and transition when matched.
  #
  # @return [void]
  def process(message)
    self.class.keywords.each do |(name, options)|
      next unless /\b#{name}\b/i.match?(message)

      if options[:from] && options[:from] == current_state
        transition_to(options[:to])
      elsif options[:method]
        public_send(options[:method])
      end

      break
    end
  end
end

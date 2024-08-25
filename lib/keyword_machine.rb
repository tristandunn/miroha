# frozen_string_literal: true

class KeywordMachine < StateMachine
  # Return the state successors for each keyword.
  #
  # @return [Hash] The state successors for keywords.
  def self.keywords
    @keywords ||= {}
  end

  # Adds state successors for a keyword.
  #
  # @param [String] name The name of the keyword.
  # @return [void]
  def self.keyword(name, from: nil, method: nil, to: nil)
    keywords[name] = {
      from:   from.to_s.presence,
      to:     to.to_s.presence,
      method: method
    }.compact
  end

  # Process a keyword and transition when matched.
  #
  # @return [void]
  def process(message)
    self.class.keywords.each do |(name, options)|
      next unless /\b#{name}\b/i.match?(message)

      if options[:from] == current_state
        transition_to(options[:to])
      elsif options[:method]
        public_send(options[:method])
      end

      break
    end
  end
end

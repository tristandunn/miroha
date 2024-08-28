# frozen_string_literal: true

module Commands
  class Base
    extend Forwardable

    PREFIX          = "Commands::"
    SPACES          = /\s+/
    THROTTLE_LIMIT  = 10
    THROTTLE_PERIOD = 5

    def_delegators :handler, :call, :locals, :render_options, :rendered?

    # Initialize a command.
    #
    # @param [String] input The raw command input.
    # @param [Character] character The character running the command.
    def initialize(input, character:)
      @character = character
      @input     = input
    end

    # Define an argument for the command class.
    #
    # @return [void]
    def self.argument(argument)
      @arguments ||= {}
      @arguments[to_s] ||= {}
      @arguments[to_s].merge!(argument)
    end

    # Return the arguments for the command class.
    #
    # @return [Hash]
    def self.arguments
      @arguments ||= {}
      @arguments[to_s] || {}
    end

    # Determine the throttle limit for the command.
    #
    # @return [Integer] The throttle limit for the command.
    def self.limit
      const_get(:THROTTLE_LIMIT)
    end

    # Determine the throttle period for the command.
    #
    # @return [Integer] The throttle period for the command.
    def self.period
      const_get(:THROTTLE_PERIOD)
    end

    private

    attr_reader :character, :input

    # Remove the command prefix and split the input into arguments separated by
    # spaces.
    #
    # @return [Array]
    def arguments
      @arguments ||= input.sub(%r{^/#{parts}(\s+|\z)}i, "").split(SPACES)
    end

    # Validate parameters and return the command handler.
    #
    # @return [Class]
    def handler
      @handler ||= validations.find(&:itself) || success
    end

    # Parse the arguments into position based parameters.
    #
    # @return [Hash]
    def parameters
      @parameters ||= self.class.arguments.each.with_object({}) do |(name, position), result|
        result[name] = Array(arguments[position]).join(" ").presence
      end
    end

    # Return the parts of the command.
    #
    #     Commands::Say
    #     # => "say"
    #     Commands::Alias::List
    #     # => "alias list"
    #
    # @return [String]
    def parts
      @parts ||= self.class.name.to_s.delete_prefix(PREFIX).gsub("::", " ").downcase
    end

    # Return a lazy enumerable to call possible validation for each parameter.
    #
    # @return [Enumerable]
    def validations
      parameters.keys.lazy.map do |parameter|
        suppress(NoMethodError) do
          send(:"validate_#{parameter}")
        end
      end
    end
  end
end

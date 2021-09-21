# frozen_string_literal: true

module Commands
  class Base
    SUFFIX = "Command"

    # Initialize a command.
    #
    # @param [String] input The raw command input.
    # @param [Character] character The character running the command.
    def initialize(input, character:)
      @character = character
      @input     = input
    end

    # Execute the command.
    #
    # @abstract Subclass and override to implement command logic.
    def call
      nil
    end

    # Determine if the command is rendered immediately.
    #
    # @return [Boolean]
    def rendered?
      false
    end

    # Return the options for rendering the command.
    #
    # @return [Hash]
    def render_options
      {
        partial: "commands/#{name}",
        locals:  locals
      }
    end

    private

    attr_reader :character, :input

    # Broadcast an append later, with automatic partial.
    #
    # @param [Array] streamables Channel streamables to broadcast to.
    # @param [String] target The append target.
    # @param [Hash] custom_render_options Custom rendering options.
    # @return [void]
    def broadcast_append_later_to(*streamables, target:, **custom_render_options)
      Turbo::StreamsChannel.broadcast_append_later_to(
        *streamables,
        target: target,
        **render_options.merge(custom_render_options)
      )
    end

    # Return the input without the command prefix.
    #
    # @return [String]
    def input_without_command
      @input_without_command ||= input.sub(%r{^/#{name}\s+}, "")
    end

    # Return the locals for the partial template.
    #
    # @return [Hash] The local variables.
    def locals
      {}
    end

    # Return the name of the command.
    #
    #     Commands::SayCommand
    #     # => "say"
    #
    # @return [String]
    def name
      @name ||= self.class.name.demodulize.delete_suffix(SUFFIX).downcase
    end
  end
end

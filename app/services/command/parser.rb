# frozen_string_literal: true

module Command
  class Parser
    DEFAULT_NAME = "say"
    MATCHER      = %r{^/([\p{L}\p{M}]+)(?=\s|$)}i

    # Initialize a command parser.
    #
    # @param [String] input The raw command input.
    # @return [void]
    def initialize(input)
      @input = input
    end

    # Convert command input to a command class.
    #
    # @param [String] input The raw command input.
    # @return [Commands::Base] The command class.
    def self.call(input)
      new(input).call
    end

    # Return a command class.
    #
    # @return [Commands::Base] The command class.
    def call
      command_class || module_class || unknown_class
    end

    private

    attr_reader :input

    # Return the class or module for the command.
    #
    # @return [Class|Module]
    def class_or_module
      @class_or_module ||= begin
        Commands.const_get(name.camelize)
      rescue NameError
        unknown_class
      end
    end

    # Return the command class.
    #
    # @return [Class] If the command class exists.
    # @return [nil] If the command class does not exist.
    def command_class
      if class_or_module < Commands::Base
        class_or_module
      end
    end

    # Return a matching module command class.
    #
    # @return [Class] If a module command matches.
    # @return [nil] If no module command matches.
    def module_class
      arguments = input.squish.split.slice(1..)

      module_classes.compact.find do |module_class|
        module_class.match?(arguments)
      end
    end

    # Return the command classes in the module.
    #
    # @return [Array]
    def module_classes
      class_or_module.constants(false).map do |name|
        module_class = class_or_module.const_get(name)

        if module_class < Commands::Base
          module_class
        end
      end
    end

    # Return the name of the command based on the internationalized name.
    #
    # @return [String]
    def name
      lookup = I18n.t("commands.lookup").transform_values { |value| value[:name] }.invert
      lookup[name_match].to_s
    end

    # Attempt to match a command name in the raw command input.
    #
    # @return [String] The matched command name when found, or the default command name.
    def name_match
      if (match = input.match(MATCHER))
        match.captures.first.downcase
      else
        DEFAULT_NAME
      end
    end

    # Returns the command class for unknown commands.
    #
    # @return [Commands::Unknown]
    def unknown_class
      Commands::Unknown
    end
  end
end

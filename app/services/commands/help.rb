# frozen_string_literal: true

module Commands
  class Help < Base
    argument name: 0

    private

    # Return the command name with forward slashes removed.
    #
    # @return [String]
    def name
      @name ||= parameters[:name].to_s.tr("/", "")
    end

    # Return the handler for a successful command execution.
    #
    # @return [Command] When a valid command name is provided.
    # @return [List] When no command name is provided.
    def success
      if name.present?
        Command.new(name: name)
      else
        List.new
      end
    end

    # Validate a command when present.
    #
    # @return [InvalidCommand] If the command is invalid.
    # @return [nil] If the command is blank or valid.
    def validate_name
      if name.present? && !I18n.exists?("commands.help.commands.#{name}")
        InvalidCommand.new(name: name)
      end
    end
  end
end

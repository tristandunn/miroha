# frozen_string_literal: true

module Commands
  module Alias
    class Add < Base
      class InvalidCommand < Result
        locals :command

        # Initialize an alias add invalid command result.
        #
        # @return [void]
        def initialize(command:)
          @command = command
        end
      end
    end
  end
end

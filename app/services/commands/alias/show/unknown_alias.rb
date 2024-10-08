# frozen_string_literal: true

module Commands
  module Alias
    class Show < Base
      class UnknownAlias < Result
        locals :name

        # Initialize an unknown alias show result.
        #
        # @param [String] name The unknown alias name.
        # @return [void]
        def initialize(name:)
          @name = name
        end
      end
    end
  end
end

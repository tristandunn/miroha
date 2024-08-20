# frozen_string_literal: true

module Commands
  module Alias
    class Show < Base
      class Success < Result
        locals :aliases

        # Initialize a successful alias show result.
        #
        # @param [Array] aliases An array of a single alias being shown.
        # @return [void]
        def initialize(aliases:)
          @aliases = aliases
        end
      end
    end
  end
end

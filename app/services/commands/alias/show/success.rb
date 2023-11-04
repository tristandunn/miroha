# frozen_string_literal: true

module Commands
  module Alias
    class Show < Base
      class Success < Result
        locals :aliases

        # Initialize a successful alias show result.
        #
        # @return [void]
        def initialize(aliases:)
          @aliases = aliases
        end
      end
    end
  end
end

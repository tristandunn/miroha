# frozen_string_literal: true

module Commands
  module Alias
    class Remove < Base
      class UnknownAlias < Result
        locals :name

        # Initialize an unknown alias remove result.
        #
        # @param [String] name The invalid alias name.
        # @return [void]
        def initialize(name:)
          @name = name
        end
      end
    end
  end
end

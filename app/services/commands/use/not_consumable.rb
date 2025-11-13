# frozen_string_literal: true

module Commands
  class Use < Base
    class NotConsumable < Result
      locals :item

      # Initialize a use not consumable result.
      #
      # @param [Item] item The non-consumable item.
      # @return [void]
      def initialize(item:)
        @item = item
      end
    end
  end
end

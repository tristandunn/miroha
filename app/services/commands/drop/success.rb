# frozen_string_literal: true

module Commands
  class Drop < Base
    class Success < Result
      locals :character, :item

      # Initialize a successful drop result.
      #
      # @param [Character] character The character dropping the item.
      # @param [Item] item The item being dropped.
      # @return [void]
      def initialize(character:, item:)
        @character = character
        @item      = item
      end

      # Transfer the item from character to room and broadcast updates.
      #
      # @return [void]
      def call
        transfer_item_to_room
        broadcast_drop
      end

      private

      # Broadcast the drop to the room.
      #
      # @return [void]
      def broadcast_drop
        broadcast_render_later_to(
          character.room_gid,
          partial: "commands/drop/observer/success",
          locals:  { character: character, item: item }
        )
      end

      # Transfer ownership of the item from character to room.
      #
      # @return [void]
      def transfer_item_to_room
        item.update!(owner: character.room)
      end
    end
  end
end

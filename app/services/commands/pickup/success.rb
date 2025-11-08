# frozen_string_literal: true

module Commands
  class Pickup < Base
    class Success < Result
      locals :character, :item

      # Initialize a successful pickup result.
      #
      # @param [Character] character The character picking up the item.
      # @param [Item] item The item being picked up.
      # @return [void]
      def initialize(character:, item:)
        @character = character
        @item      = item
      end

      # Transfer the item from room to character and broadcast updates.
      #
      # @return [void]
      def call
        transfer_item_to_character
        broadcast_pickup
      end

      private

      # Broadcast the pickup to the room.
      #
      # @return [void]
      def broadcast_pickup
        broadcast_render_later_to(
          character.room_gid,
          partial: "commands/pickup/observer/success",
          locals:  { character: character, item: item }
        )
      end

      # Transfer ownership of the item from room to character.
      # If the item is stackable, attempt to merge it with existing stacks.
      #
      # @return [void]
      def transfer_item_to_character
        if item.stackable?
          Items::Stack.call(character: character, item: item)
        else
          item.update!(owner: character)
        end
      end
    end
  end
end

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

      # Transfer ownership of the item and broadcast the pickup to the room.
      #
      # @return [void]
      def call
        transfer_ownership
        broadcast_pickup
      end

      private

      attr_reader :character, :item

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
      #
      # @return [void]
      def transfer_ownership
        item.update!(owner: character)
      end
    end
  end
end

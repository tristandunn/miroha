# frozen_string_literal: true

module Commands
  class Use < Base
    class Success < Result
      locals :character, :item, :health_restored

      # Initialize a successful use result.
      #
      # @param [Character] character The character using the item.
      # @param [Item] item The item being used.
      # @return [void]
      def initialize(character:, item:)
        @character = character
        @item      = item
      end

      # Consume the item and restore health, then broadcast updates.
      #
      # @return [void]
      def call
        restore_health
        consume_item
        broadcast_use
      end

      private

      # Broadcast the use action to the room.
      #
      # @return [void]
      def broadcast_use
        broadcast_render_later_to(
          character.room_gid,
          partial: "commands/use/observer/success",
          locals:  { character: character, item: item, health_restored: health_restored }
        )
      end

      # Consume the item by decrementing quantity or destroying it.
      # If stackable and quantity > 1, decrement. Otherwise, destroy.
      #
      # @return [void]
      def consume_item
        if item.stackable? && item.quantity > 1
          item.update!(quantity: item.quantity - 1)
        else
          item.destroy!
        end
      end

      # The amount of health restored from the item.
      #
      # @return [Integer]
      def health_restored
        @health_restored
      end

      # Restore the character's health by the item's heal amount.
      #
      # @return [void]
      def restore_health
        heal_amount = item.metadata["heal_amount"] || 0
        new_health = [
          character.current_health + heal_amount,
          character.maximum_health
        ].min

        @health_restored = new_health - character.current_health
        character.update!(current_health: new_health)
      end
    end
  end
end

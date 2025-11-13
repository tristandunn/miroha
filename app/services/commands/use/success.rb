# frozen_string_literal: true

module Commands
  class Use < Base
    class Success < Result
      locals :character, :item, :adjusted_health

      # Initialize a successful use result.
      #
      # @param [Character] character The character using the item.
      # @param [Item] item The item being used.
      # @return [void]
      def initialize(character:, item:)
        @character = character
        @item      = item
      end

      # Apply item properties and consume item, then broadcast updates.
      #
      # @return [void]
      def call
        apply_properties
        broadcast_use
        consume_item
      end

      private

      # The amount of health adjusted (positive for healing, could be negative for harm).
      # Calculated as the minimum of the item's health value and available health to restore.
      #
      # @return [Integer]
      def adjusted_health
        @adjusted_health
      end

      # Adjust the character's current health based on the item's health property.
      # Calculates and caches the adjusted_health value before updating.
      #
      # @return [void]
      def adjust_current_health
        health_value = item.metadata["health"] || 0
        new_health = [
          character.current_health + health_value,
          character.maximum_health
        ].min

        @adjusted_health = new_health - character.current_health
        character.update!(current_health: new_health)
      end

      # Apply item properties to the character.
      #
      # @return [void]
      def apply_properties
        adjust_current_health
      end

      # Broadcast the use action to the room.
      #
      # @return [void]
      def broadcast_use
        broadcast_render_later_to(
          character.room_gid,
          partial: "commands/use/observer/success",
          locals:  { character: character, name: item.name }
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
    end
  end
end

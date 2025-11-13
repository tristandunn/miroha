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
      #
      # @return [Integer]
      def adjusted_health
        @adjusted_health ||= calculate_adjusted_health
      end

      # Adjust the character's current health based on the adjusted_health value.
      #
      # @return [void]
      def adjust_current_health
        new_health = character.current_health + adjusted_health
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

      # Calculate the amount of health that will be adjusted.
      # Takes into account the item's health value and character's available health.
      #
      # @return [Integer]
      def calculate_adjusted_health
        health_value = item.metadata["health"] || 0
        available_health = character.maximum_health - character.current_health
        [health_value, available_health].min
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

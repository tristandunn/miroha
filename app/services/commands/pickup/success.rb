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
          merge_into_existing_stacks
        else
          item.update!(owner: character)
        end
      end

      # Merge the picked-up item into existing stacks in character's inventory.
      # Creates new stacks as needed if the item can't be fully merged.
      #
      # @return [void]
      def merge_into_existing_stacks
        remaining_quantity = fill_existing_stacks
        create_new_stacks(remaining_quantity)
        item.destroy!
      end

      # Fill existing partial stacks with the picked-up item quantity.
      #
      # @return [Integer] The remaining quantity after filling existing stacks.
      def fill_existing_stacks
        remaining_quantity = item.quantity

        available_stacks.each do |stack|
          break if remaining_quantity.zero?

          amount_to_add = [remaining_quantity, stack.available_stack_space].min
          stack.update!(quantity: stack.quantity + amount_to_add)
          remaining_quantity -= amount_to_add
        end

        remaining_quantity
      end

      # Find existing stacks with the same name and metadata that have space.
      #
      # @return [ActiveRecord::Relation]
      def available_stacks
        character.items
                 .where(name: item.name, metadata: item.metadata)
                 .where(quantity: ...item.max_stack)
                 .order(:quantity)
      end

      # Create new stacks for any remaining quantity.
      #
      # @param [Integer] remaining_quantity The quantity to create new stacks for.
      # @return [void]
      def create_new_stacks(remaining_quantity)
        while remaining_quantity.positive?
          amount = [remaining_quantity, item.max_stack].min
          character.items.create!(name: item.name, metadata: item.metadata, quantity: amount)
          remaining_quantity -= amount
        end
      end
    end
  end
end

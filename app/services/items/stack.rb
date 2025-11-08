# frozen_string_literal: true

module Items
  class Stack
    # Merge the item into the character's inventory, filling existing stacks
    # and creating new ones as needed. Destroys the original item.
    #
    # @param [Character] character The character receiving the item.
    # @param [Item] item The item to be stacked into the character's inventory.
    # @return [void]
    def self.call(character:, item:)
      remaining_quantity = fill_existing_stacks(character: character, item: item)
      create_new_stacks(character: character, item: item, quantity: remaining_quantity)
      item.destroy!
    end

    # Fill existing partial stacks with the picked-up item quantity.
    #
    # @param [Character] character The character receiving the item.
    # @param [Item] item The item to be stacked.
    # @return [Integer] The remaining quantity after filling existing stacks.
    def self.fill_existing_stacks(character:, item:)
      remaining_quantity = item.quantity

      available_stacks(character: character, item: item).each do |stack|
        break if remaining_quantity.zero?

        available_space = stack.max_stack - stack.quantity
        amount_to_add   = [remaining_quantity, available_space].min

        stack.update!(quantity: stack.quantity + amount_to_add)
        remaining_quantity -= amount_to_add
      end

      remaining_quantity
    end
    private_class_method :fill_existing_stacks

    # Find existing stacks with the same name and metadata that have space.
    #
    # @param [Character] character The character whose inventory to search.
    # @param [Item] item The item to find matching stacks for.
    # @return [ActiveRecord::Relation]
    def self.available_stacks(character:, item:)
      character.items
               .where(name: item.name, metadata: item.metadata)
               .where(quantity: ...item.max_stack)
               .order(:quantity)
    end
    private_class_method :available_stacks

    # Create new stacks for any remaining quantity.
    #
    # @param [Character] character The character receiving the item.
    # @param [Item] item The item template for new stacks.
    # @param [Integer] quantity The quantity to create new stacks for.
    # @return [void]
    def self.create_new_stacks(character:, item:, quantity:)
      while quantity.positive?
        amount = [quantity, item.max_stack].min
        character.items.create!(name: item.name, metadata: item.metadata, quantity: amount)
        quantity -= amount
      end
    end
    private_class_method :create_new_stacks
  end
end

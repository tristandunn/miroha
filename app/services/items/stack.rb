# frozen_string_literal: true

module Items
  class Stack
    # Initialize an instance.
    #
    # @param [Character] character The character receiving the item.
    # @param [Item] item The item to be stacked into the character's inventory.
    # @return [void]
    def initialize(character:, item:)
      @character = character
      @item = item
    end

    # Create and call an instance.
    #
    # @param [Character] character The character receiving the item.
    # @param [Item] item The item to be stacked into the character's inventory.
    # @return [void]
    def self.call(character:, item:)
      new(character: character, item: item).call
    end

    # Merge the item into the character's inventory, filling existing stacks
    # and creating new ones as needed. Destroys the original item.
    #
    # @return [void]
    def call
      remaining_quantity = fill_existing_stacks
      create_new_stacks(remaining_quantity)
      item.destroy!
    end

    private

    attr_reader :character, :item

    # Fill existing partial stacks with the picked-up item quantity.
    #
    # @return [Integer] The remaining quantity after filling existing stacks.
    def fill_existing_stacks
      remaining_quantity = item.quantity

      available_stacks.each do |stack|
        break if remaining_quantity.zero?

        available_space = stack.stack_limit - stack.quantity
        amount_to_add   = [remaining_quantity, available_space].min

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
               .where(quantity: ...item.stack_limit)
               .order(:quantity)
    end

    # Create new stacks for any remaining quantity.
    #
    # @param [Integer] quantity The quantity to create new stacks for.
    # @return [void]
    def create_new_stacks(quantity)
      while quantity.positive?
        amount = [quantity, item.stack_limit].min
        character.items.create!(name: item.name, metadata: item.metadata, quantity: amount)
        quantity -= amount
      end
    end
  end
end

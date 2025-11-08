# frozen_string_literal: true

# Service for merging stackable items into a character's inventory.
class ItemStacker
  # Initialize the stacker with the character and item to stack.
  #
  # @param [Character] character The character receiving the item.
  # @param [Item] item The item to be stacked into the character's inventory.
  # @return [void]
  def initialize(character:, item:)
    @character = character
    @item = item
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

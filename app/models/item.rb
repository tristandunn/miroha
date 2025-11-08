# frozen_string_literal: true

class Item < ApplicationRecord
  MINIMUM_NAME_LENGTH = 3
  MAXIMUM_NAME_LENGTH = 24
  DEFAULT_MAX_STACK   = 1

  belongs_to :owner, polymorphic: true, optional: true

  validates :name, presence: true,
                   length:   { in: MINIMUM_NAME_LENGTH..MAXIMUM_NAME_LENGTH }
  validates :quantity, numericality: { greater_than: 0, only_integer: true }
  validate :quantity_within_stack_limit

  # Return the maximum stack size for this item.
  #
  # @return [Integer]
  def max_stack
    metadata["max_stack"] || DEFAULT_MAX_STACK
  end

  # Return if the item is stackable (max_stack > 1).
  #
  # @return [Boolean]
  def stackable?
    max_stack > 1
  end

  # Return if the stack can accept more items.
  #
  # @return [Boolean]
  def can_stack_more?
    quantity < max_stack
  end

  # Return how many more items can be added to this stack.
  #
  # @return [Integer]
  def available_stack_space
    max_stack - quantity
  end

  private

  # Validate that quantity does not exceed max_stack.
  #
  # @return [void]
  def quantity_within_stack_limit
    return if quantity.blank? || quantity <= max_stack

    errors.add(:quantity, "cannot exceed maximum stack size of #{max_stack}")
  end
end

# frozen_string_literal: true

class Item < ApplicationRecord
  MINIMUM_NAME_LENGTH  = 3
  MAXIMUM_NAME_LENGTH  = 24
  DEFAULT_STACK_LIMIT  = 1

  belongs_to :owner, polymorphic: true, optional: true

  validates :name, presence: true,
                   length:   { in: MINIMUM_NAME_LENGTH..MAXIMUM_NAME_LENGTH }
  validates :quantity, numericality: { greater_than: 0, less_than_or_equal_to: :stack_limit, only_integer: true }

  # Return the maximum stack size for this item.
  #
  # @return [Integer]
  def stack_limit
    metadata["stack_limit"] || DEFAULT_STACK_LIMIT
  end

  # Return if the item is stackable (stack_limit > 1).
  #
  # @return [Boolean]
  def stackable?
    stack_limit > 1
  end
end

# frozen_string_literal: true

module Commands
  class Use < Base
    argument name: (0..)

    private

    # Attempt to find the item by name, including partial matches.
    # Prioritizes consumable items with the lowest quantity (for stacks).
    #
    # @return [Item] If an item is found.
    # @return [nil] If an item is not found.
    def item
      return @item if defined?(@item)

      @item = character.items
                       .where("LOWER(name) LIKE ?", "%#{parameters[:name].downcase}%")
                       .order(:quantity)
                       .first
    end

    # Return the handler for a successful command execution.
    #
    # @return [Success] If the item was successfully used.
    def success
      Success.new(character: character, item: item)
    end

    # Validate a name parameter is present, the item exists in the
    # character's inventory, and the item is consumable.
    #
    # @return [MissingItem] If the name parameter is blank.
    # @return [InvalidItem] If the item is not found in the character's inventory.
    # @return [NotConsumable] If the item is not marked as consumable.
    # @return [nil] If the item is valid.
    def validate_name
      if parameters[:name].blank?
        MissingItem.new
      elsif item.nil?
        InvalidItem.new(name: parameters[:name])
      elsif item.metadata.dig("consumable") != true
        NotConsumable.new(item: item)
      end
    end
  end
end

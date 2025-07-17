# frozen_string_literal: true

module Commands
  class Drop < Base
    argument name: (0..)

    private

    # Attempt to find the item by name, including partial matches.
    #
    # @return [Item] If an item is found.
    # @return [nil] If an item is not found.
    def item
      return @item if defined?(@item)

      @item = character.items
                       .where("LOWER(name) LIKE ?", "%#{parameters[:name].downcase}%")
                       .first
    end

    # Return the handler for a successful command execution.
    #
    # @return [Success] If the item was successfully dropped.
    def success
      Success.new(character: character, item: item)
    end

    # Validate a name parameter is present and the item exists in the
    # character's inventory.
    #
    # @return [MissingItem] If the name parameter is blank.
    # @return [InvalidItem] If the item is not found in the character's inventory.
    # @return [nil] If the item is valid.
    def validate_name
      if parameters[:name].blank?
        MissingItem.new
      elsif item.nil?
        InvalidItem.new(name: parameters[:name])
      end
    end
  end
end

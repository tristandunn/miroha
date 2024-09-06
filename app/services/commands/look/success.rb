# frozen_string_literal: true

module Commands
  class Look < Base
    class Success < Result
      locals :description

      # Initialize a successful look result.
      #
      # @param [Character] character The character looking at the object.
      # @param [String] object The optional object to look at.
      # @return [void]
      def initialize(character:, object:)
        @character = character
        @object    = object
      end

      private

      attr_reader :character, :object

      # Return the description for looking.
      #
      # @return [String]
      def description
        if object.present?
          object_description ||
            I18n.t("commands.look.unknown", target: object)
        else
          room.description
        end
      end

      # Returns the object description if present.
      #
      # @return [String] Description of the room object if present.
      # @return [nil] If no object description is present.
      def object_description
        objects = room.objects
        objects[object] || objects[object.pluralize] || objects[object.singularize]
      end

      # Return the character's room.
      #
      # @return [Room]
      def room
        @room ||= character.room
      end
    end
  end
end

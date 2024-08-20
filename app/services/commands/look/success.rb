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

      # Return the article for the object.
      #
      # @return [String]
      def article
        object.indefinite_article
      end

      # Return the description for looking.
      #
      # @return [String]
      def description
        if object.present?
          room.objects[object].presence ||
            I18n.t("commands.look.unknown", article: article, target: object)
        else
          room.description
        end
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

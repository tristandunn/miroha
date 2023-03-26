# frozen_string_literal: true

module Commands
  class LookCommand < Base
    # Determine if the command is rendered immediately.
    #
    # @return [Boolean]
    def rendered?
      true
    end

    private

    alias object input_without_command

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

    # Return the locals for the partial template.
    #
    # @return [Hash] The local variables.
    def locals
      {
        description: description
      }
    end

    # Return the character's room.
    #
    # @return [Room]
    def room
      @room ||= character.room
    end
  end
end

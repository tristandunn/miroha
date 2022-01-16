# frozen_string_literal: true

module Clock
  class SignOutInactiveCharacters
    # Sign out inactive characters that are playing.
    #
    # @return [void]
    def self.call
      Character.inactive.playing.find_each do |character|
        mark_as_not_playing(character)
        sign_out(character)
      end
    end

    # Mark the character as no longer playing to ensure the clock task doesn't
    # run again before the character exits the game.
    #
    # @param [Character] character The character exiting the game.
    # @return [void]
    def self.mark_as_not_playing(character)
      character.update(playing: false)
    end
    private_class_method :mark_as_not_playing

    # Broadcast message to character triggering them to exit the game.
    #
    # @param [Character] character The character exiting the game.
    # @return [void]
    def self.sign_out(character)
      Turbo::StreamsChannel.broadcast_append_to(
        character,
        target:  "messages",
        partial: "commands/exit_game"
      )
    end
    private_class_method :sign_out
  end
end

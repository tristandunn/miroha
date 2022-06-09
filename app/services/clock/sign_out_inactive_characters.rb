# frozen_string_literal: true

module Clock
  class SignOutInactiveCharacters < Base
    INTERVAL = 1.minute
    NAME     = "Sign out inactive characters."

    # Sign out inactive characters that are playing.
    #
    # @return [void]
    def call
      Character.inactive.playing.find_each do |character|
        mark_as_not_playing(character)
        sign_out(character)
      end
    end

    private

    # Mark the character as no longer playing to ensure the clock task doesn't
    # run again before the character exits the game.
    #
    # @param [Character] character The character exiting the game.
    # @return [void]
    def mark_as_not_playing(character)
      character.update(playing: false)
    end

    # Broadcast message to character triggering them to exit the game.
    #
    # @param [Character] character The character exiting the game.
    # @return [void]
    def sign_out(character)
      Turbo::StreamsChannel.broadcast_append_to(
        character,
        target:  "messages",
        partial: "commands/exit_game"
      )
    end
  end
end

# frozen_string_literal: true

module Clock
  class RegenerateHealth < Base
    INTERVAL = 30.seconds
    NAME     = "Regenerate health of injured characters and monsters."

    # Regenerate the health of injured characters and monsters.
    #
    # @return [void]
    def call
      regenerate_injured_characters_health
      regenerate_injured_monsters_health
    end

    private

    # Broadcast a sidebar character replacement to the target character.
    #
    # @param [Character] character The character to broadcast to.
    # @return [void]
    def broadcast_sidebar_to(character)
      Turbo::StreamsChannel.broadcast_replace_later_to(
        character,
        target:  :character,
        partial: "game/sidebar/character",
        locals:  { character: character }
      )
    end

    # Returns a relation of active, playing characters that are injured.
    #
    # @return [ActiveRecord::Relation]
    def injured_characters
      Character.active.playing.where("current_health < maximum_health")
    end

    # Returns a relation of monsters that are injured.
    #
    # @return [ActiveRecord::Relation]
    def injured_monsters
      Monster.where("current_health < maximum_health")
    end

    # Regenerate injured characters health and broadcast a sidebar replacement.
    #
    # @return [void]
    def regenerate_injured_characters_health
      injured_characters.find_each do |character|
        character.current_health += 1
        character.save!

        broadcast_sidebar_to(character)
      end
    end

    # Regenerate injured monsters health.
    #
    # @return [void]
    def regenerate_injured_monsters_health
      injured_monsters.update_counters(current_health: 1) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end

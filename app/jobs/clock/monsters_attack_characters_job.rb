# frozen_string_literal: true

module Clock
  class MonstersAttackCharactersJob < ApplicationJob
    LIMIT = 128

    # Triggers monster attacks for monsters in rooms with active,
    # playing characters.
    #
    # @return [void]
    def perform
      monsters_to_attack.each do |monster|
        Monsters::Attack.call(monster)
      end
    end

    private

    # Find the unique room IDs for all active, playing characters.
    #
    # @return [Array]
    def character_room_ids
      Character.active.playing.distinct.pluck(:room_id)
    end

    # Find monsters that can attack.
    #
    # @return [ActiveRecord::Relation]
    def monsters_to_attack
      Monster
        .where(room_id: character_room_ids)
        .limit(LIMIT)
    end
  end
end

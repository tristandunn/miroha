# frozen_string_literal: true

module Clock
  class ActivateSpawns < Base
    INTERVAL = 1.minute
    LIMIT    = 128
    NAME     = "Activate spawns."

    # Activates spawns due to be activated.
    #
    # @return [void]
    def call
      spawns_to_activate.each do |spawn|
        Spawns::Activate.call(spawn)

        broadcast_spawn(spawn)
      end
    end

    private

    # Broadcast the entity spawn to the room.
    #
    # @param [Spawn] spawn The spawn to broadcast.
    def broadcast_spawn(spawn)
      entity_type = spawn.entity.class.to_s.downcase

      Turbo::StreamsChannel.broadcast_append_later_to(
        spawn.room,
        target:  "surrounding-#{entity_type.pluralize}",
        partial: "game/surroundings/#{entity_type}",
        locals:  { entity_type.to_sym => spawn.entity }
      )
    end

    # Find spawns due to be activated.
    #
    # @return [ActiveRecord::Relation]
    def spawns_to_activate
      Spawn
        .includes(:base, :room)
        .where(activates_at: ..Time.current)
        .order(activates_at: :asc)
        .limit(LIMIT)
    end
  end
end

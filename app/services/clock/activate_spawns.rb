# frozen_string_literal: true

module Clock
  class ActivateSpawns
    LIMIT = 128

    # Activates spawns due to be activated.
    #
    # @return [void]
    def self.call
      spawns_to_activate.each do |spawn|
        Spawns::Activate.call(spawn)

        broadcast_spawn(spawn)
      end
    end

    # Broadcast the entity spawn to the room.
    #
    # @param [Spawn] spawn The spawn to broadcast.
    def self.broadcast_spawn(spawn)
      entity_type = spawn.entity.class.to_s.downcase

      Turbo::StreamsChannel.broadcast_append_later_to(
        spawn.room,
        target:  "surrounding-#{entity_type.pluralize}",
        partial: "game/surroundings/#{entity_type}",
        locals:  { entity_type.to_sym => spawn.entity }
      )
    end
    private_class_method :broadcast_spawn

    # Find spawns due to be activated.
    #
    # @return [ActiveRecord::Relation]
    def self.spawns_to_activate
      Spawn
        .includes(:base, :room)
        .where("activates_at <= ?", Time.current)
        .order(activates_at: :asc)
        .limit(LIMIT)
    end
    private_class_method :spawns_to_activate
  end
end

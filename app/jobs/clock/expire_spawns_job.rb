# frozen_string_literal: true

module Clock
  class ExpireSpawnsJob < ApplicationJob
    LIMIT = 128

    # Expires spawns due to be expired.
    #
    # @return [void]
    def perform
      spawns_to_expire.each do |spawn|
        broadcast_despawn(spawn)
        Spawns::Expire.call(spawn)
      end
    end

    private

    # Broadcast the entity despawn to the room.
    #
    # @param [Spawn] spawn The spawn to broadcast.
    def broadcast_despawn(spawn)
      return unless spawn.entity

      entity_type = spawn.entity.class.to_s.downcase

      Turbo::StreamsChannel.broadcast_remove_to(
        spawn.room,
        target: "surrounding_#{entity_type}_#{spawn.entity.id}"
      )
    end

    # Find spawns due to be expired.
    #
    # @return [ActiveRecord::Relation]
    def spawns_to_expire
      Spawn
        .includes(:entity, :room)
        .where(expires_at: ..Time.current)
        .order(expires_at: :asc)
        .limit(LIMIT)
    end
  end
end

# frozen_string_literal: true

module Spawns
  class Activate
    # Activates a spawn by building the entity, clearing the activation time,
    # and assigning an expiration time if the spawn has a duration.
    #
    # @param [Spawn] spawn The spawn to activate.
    # @return [void]
    def self.call(spawn)
      spawn.update!(
        activates_at: nil,
        entity:       build_entity(spawn),
        expires_at:   spawn.duration ? Time.current + spawn.duration : nil
      )
    end

    # Duplicate the spawn base entity, assign the spawn room to the entity,
    # duplicate and assign any items, and return the new entity.
    #
    # @param [Spawn] spawn The spawn to build an entity for.
    # @return [Monster] The entity created.
    def self.build_entity(spawn)
      entity = spawn.base.dup
      entity.room_id = spawn.room_id
      entity.items   = spawn.base.items.map(&:dup)
      entity
    end
    private_class_method :build_entity
  end
end

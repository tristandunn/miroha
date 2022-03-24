# frozen_string_literal: true

module Spawns
  class Activate
    # Activates a spawn by creating the entity, clearing the activation time,
    # and assigning an expiration time if the spawn has a duration.
    #
    # @param [Spawn] spawn The spawn to activate.
    # @return [void]
    def self.call(spawn)
      spawn.update!(
        activates_at: nil,
        entity:       spawn.base.dup,
        expires_at:   spawn.duration ? Time.current + spawn.duration : nil
      )
    end
  end
end

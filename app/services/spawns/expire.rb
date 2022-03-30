# frozen_string_literal: true

module Spawns
  class Expire
    # Expires a spawn by destroying the entity, clearing the expiration time,
    # and assigning an activation time if the spawn has a frequency.
    #
    # @param [Spawn] spawn The spawn to expire.
    # @return [void]
    def self.call(spawn)
      spawn.transaction do
        spawn.entity&.destroy!
        spawn.update!(
          activates_at: spawn.frequency ? Time.current + spawn.frequency : nil,
          entity:       nil,
          expires_at:   nil
        )
      end
    end
  end
end

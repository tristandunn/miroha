# frozen_string_literal: true

module Clock
  class ExpireSpawns
    LIMIT = 128

    # Expires spawns due to be expried.
    #
    # @return [void]
    def self.call
      spawns_to_expire.each do |spawn|
        expire!(spawn)
      end
    end

    # Expires the provided spawn.
    #
    # @param [Spawn] spawn The spawn to expire.
    def self.expire!(spawn)
      spawn.transaction do
        spawn.entity.destroy!
        spawn.update!(
          activates_at: spawn.frequency ? Time.current + spawn.frequency : nil,
          entity:       nil,
          expires_at:   nil
        )
      end
    end
    private_class_method :expire!

    # Find spawns due to be expired.
    #
    # @return [ActiveRecord::Relation]
    def self.spawns_to_expire
      Spawn
        .includes(:entity)
        .where("expires_at <= ?", Time.current)
        .order(expires_at: :asc)
        .limit(LIMIT)
    end
    private_class_method :spawns_to_expire
  end
end

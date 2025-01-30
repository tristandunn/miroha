# frozen_string_literal: true

module Clock
  class ExpireSpawnsJob < ApplicationJob
    LIMIT = 128

    # Expires spawns due to be expired.
    #
    # @return [void]
    def perform
      spawns_to_expire.each do |spawn|
        Spawns::Expire.call(spawn)
      end
    end

    private

    # Find spawns due to be expired.
    #
    # @return [ActiveRecord::Relation]
    def spawns_to_expire
      Spawn
        .includes(:entity)
        .where(expires_at: ..Time.current)
        .order(expires_at: :asc)
        .limit(LIMIT)
    end
  end
end

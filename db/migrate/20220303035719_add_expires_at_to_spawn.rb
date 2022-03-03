# frozen_string_literal: true

class AddExpiresAtToSpawn < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :spawns, :expires_at, :datetime
    add_index :spawns, :expires_at, where: "entity_id IS NOT NULL", algorithm: :concurrently
  end
end

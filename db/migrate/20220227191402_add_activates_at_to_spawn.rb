# frozen_string_literal: true

class AddActivatesAtToSpawn < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :spawns, :activates_at, :datetime
    add_index :spawns, :activates_at, where: "entity_id IS NULL"
  end
end

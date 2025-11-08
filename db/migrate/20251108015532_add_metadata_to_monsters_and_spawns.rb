# frozen_string_literal: true

class AddMetadataToMonstersAndSpawns < ActiveRecord::Migration[8.0]
  def change
    add_column :monsters, :metadata, :jsonb, default: {}, null: false
    add_column :spawns, :metadata, :jsonb, default: {}, null: false

    add_index :monsters, :metadata, using: :gin
    add_index :spawns, :metadata, using: :gin
  end
end

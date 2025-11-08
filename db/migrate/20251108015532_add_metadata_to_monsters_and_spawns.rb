# frozen_string_literal: true

class AddMetadataToMonstersAndSpawns < ActiveRecord::Migration[8.0]
  def change
    change_table :monsters do |t|
      t.jsonb :metadata, default: {}, null: false
      t.index :metadata, using: :gin
    end

    change_table :spawns do |t|
      t.jsonb :metadata, default: {}, null: false
      t.index :metadata, using: :gin
    end
  end
end

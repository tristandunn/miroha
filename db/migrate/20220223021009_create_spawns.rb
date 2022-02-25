# frozen_string_literal: true

class CreateSpawns < ActiveRecord::Migration[7.0]
  def change
    create_table :spawns do |t|
      t.references :base, null: false, polymorphic: true
      t.references :entity, null: true, polymorphic: true
      t.references :room, null: false

      t.timestamps
    end
  end
end

# frozen_string_literal: true

class CreateNpcs < ActiveRecord::Migration[8.0]
  def change
    create_table :npcs do |t|
      t.references :room, null: true, foreign_key: true, index: true

      t.string :name, null: false, limit: 24

      t.timestamps
    end
  end
end

# frozen_string_literal: true

class CreateMonsters < ActiveRecord::Migration[7.0]
  def change
    create_table :monsters do |t|
      t.references :room, null: false, index: true

      t.string :name, null: false, limit: 24

      t.timestamps
    end
  end
end

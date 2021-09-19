# frozen_string_literal: true

class CreateCharacters < ActiveRecord::Migration[6.1]
  def change
    create_table :characters do |t|
      t.references :account, null: false, foreign_key: true

      t.string :name, null: false, limit: 12

      t.timestamps null: false

      t.index :name, unique: true
    end
  end
end

# frozen_string_literal: true

class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.bigint :x,           null: false
      t.bigint :y,           null: false
      t.bigint :z,           null: false
      t.string :description, null: false

      t.timestamps null: false

      t.index %i(x y z), unique: true
    end
  end
end

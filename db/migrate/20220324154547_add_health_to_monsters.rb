# frozen_string_literal: true

class AddHealthToMonsters < ActiveRecord::Migration[7.0]
  def change
    change_table :monsters, bulk: true do |t|
      t.integer :current_health, null: false, default: 5
      t.integer :maximum_health, null: false, default: 5
    end
  end
end

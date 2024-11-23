# frozen_string_literal: true

class AddHealthToCharacters < ActiveRecord::Migration[7.0]
  def change
    change_table :characters, bulk: true do |t|
      t.integer :current_health, null: false, default: 10
      t.integer :maximum_health, null: false, default: 10
    end
  end
end

# frozen_string_literal: true

class AddLevelToCharacters < ActiveRecord::Migration[6.1]
  def change
    change_table :characters do |t|
      t.integer :level, null: false, default: 1
    end
  end
end

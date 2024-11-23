# frozen_string_literal: true

class AddExperienceToCharacters < ActiveRecord::Migration[6.1]
  def change
    change_table :characters do |t|
      t.integer :experience, null: false, default: 0
    end
  end
end

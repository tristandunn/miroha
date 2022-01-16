# frozen_string_literal: true

class AddExperienceToCharacters < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      change_table :characters do |t|
        t.integer :experience, null: false, default: 0
      end
    end
  end
end

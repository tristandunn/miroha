# frozen_string_literal: true

class AddExperienceToMonsters < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      change_table :monsters do |t|
        t.integer :experience, null: false, default: 0
      end
    end
  end
end

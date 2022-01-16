# frozen_string_literal: true

class AddRoomToCharacters < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      change_table :characters do |t|
        t.references :room, null: false, index: true
      end
    end
  end
end

# frozen_string_literal: true

class AddRoomToCharacters < ActiveRecord::Migration[6.1]
  def change
    change_table :characters do |t|
      t.references :room, null: false, index: true
    end
  end
end

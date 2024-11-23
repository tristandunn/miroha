# frozen_string_literal: true

class AddActiveAtToCharacters < ActiveRecord::Migration[6.1]
  def change
    change_table :characters do |t|
      t.datetime :active_at, null: false, default: -> { "CURRENT_TIMESTAMP" }, index: true

      t.index %i(room_id active_at)
      t.remove_index :room_id
    end
  end
end

# frozen_string_literal: true

class AddObjectsToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :objects, :jsonb, default: {}, null: false
  end
end

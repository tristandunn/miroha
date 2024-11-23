# frozen_string_literal: true

class AddRoomToMonsters < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_reference :monsters, :room, index: true
    add_foreign_key :monsters, :rooms, validate: false
  end
end

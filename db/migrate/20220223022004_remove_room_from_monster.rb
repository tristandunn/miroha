# frozen_string_literal: true

class RemoveRoomFromMonster < ActiveRecord::Migration[7.0]
  def change
    remove_reference :monsters, :room, index: true
  end
end

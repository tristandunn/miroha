# frozen_string_literal: true

class RemoveRoomFromMonster < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      remove_reference :monsters, :room, index: true
    end
  end
end

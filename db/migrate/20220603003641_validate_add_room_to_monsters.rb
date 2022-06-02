# frozen_string_literal: true

class ValidateAddRoomToMonsters < ActiveRecord::Migration[7.0]
  def change
    validate_foreign_key :monsters, :rooms
  end
end

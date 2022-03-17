# frozen_string_literal: true

class AddDurationToSpawns < ActiveRecord::Migration[7.0]
  def change
    add_column :spawns, :duration, :bigint
  end
end

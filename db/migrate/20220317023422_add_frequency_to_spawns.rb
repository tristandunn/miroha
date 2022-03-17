# frozen_string_literal: true

class AddFrequencyToSpawns < ActiveRecord::Migration[7.0]
  def change
    add_column :spawns, :frequency, :bigint
  end
end

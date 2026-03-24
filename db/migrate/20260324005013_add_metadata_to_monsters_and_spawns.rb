# frozen_string_literal: true

class AddMetadataToMonstersAndSpawns < ActiveRecord::Migration[8.1]
  def change
    change_table :monsters do |t|
      t.json :metadata, default: {}, null: false, index: true
    end

    change_table :spawns do |t|
      t.json :metadata, default: {}, null: false, index: true
    end
  end
end

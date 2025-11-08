# frozen_string_literal: true

class AddStackingToItems < ActiveRecord::Migration[8.0]
  def change
    change_table :items do |t|
      t.integer :quantity, default: 1, null: false
      t.json :metadata, default: {}, null: false
    end
  end
end

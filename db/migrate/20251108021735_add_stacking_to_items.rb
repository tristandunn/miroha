# frozen_string_literal: true

class AddStackingToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :quantity, :integer, default: 1, null: false
    add_column :items, :metadata, :json, default: {}, null: false
  end
end

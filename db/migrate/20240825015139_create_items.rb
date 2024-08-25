# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.references :owner, null: false, polymorphic: true

      t.string :name, null: false, limit: 24

      t.timestamps
    end
  end
end

# frozen_string_literal: true

class AddEventHandlersToMonsters < ActiveRecord::Migration[7.0]
  def change
    change_table :monsters do |t|
      t.json :event_handlers, array: true, default: [], null: false
      t.index :event_handlers
    end
  end
end

# frozen_string_literal: true

class AddPlayingToCharacter < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :characters, :playing, :boolean, null: false, default: false

    add_index :characters, %i(active_at playing)
    remove_index :characters, :active_at
  end
end

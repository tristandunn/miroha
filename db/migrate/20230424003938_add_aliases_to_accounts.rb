# frozen_string_literal: true

class AddAliasesToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :aliases, :jsonb, default: {}, null: false
  end
end

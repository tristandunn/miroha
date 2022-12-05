# frozen_string_literal: true

class AddCurrentHealthConstraints < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :characters,
                         "current_health <= maximum_health",
                         name:     "characters_current_health_check",
                         validate: false
    add_check_constraint :monsters,
                         "current_health <= maximum_health",
                         name:     "monsters_current_health_check",
                         validate: false
  end
end

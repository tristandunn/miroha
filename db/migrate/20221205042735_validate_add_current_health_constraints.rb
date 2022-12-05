# frozen_string_literal: true

class ValidateAddCurrentHealthConstraints < ActiveRecord::Migration[7.0]
  def change
    validate_check_constraint :characters, name: "characters_current_health_check"
    validate_check_constraint :monsters, name: "monsters_current_health_check"
  end
end

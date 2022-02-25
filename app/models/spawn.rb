# frozen_string_literal: true

class Spawn < ApplicationRecord
  belongs_to :base, polymorphic: true
  belongs_to :entity, polymorphic: true, optional: true, dependent: :destroy
  belongs_to :room
end

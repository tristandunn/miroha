# frozen_string_literal: true

class Interaction < ApplicationRecord
  belongs_to :character
  belongs_to :npc
end

# frozen_string_literal: true

FactoryBot.define do
  factory :spawn do
    room

    trait :monster do
      base { create(:monster, room: nil) }
      entity { build(:monster, room: room) }
    end
  end
end

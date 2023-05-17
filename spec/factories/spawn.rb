# frozen_string_literal: true

FactoryBot.define do
  factory :spawn do
    room

    trait :monster do
      base { association(:monster, room: nil) }
      entity { association(:monster, room: room) }
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :character do
    account
    room
    name

    trait :inactive do
      active_at { Character::ACTIVE_DURATION.ago - 1.minute }
    end
  end
end

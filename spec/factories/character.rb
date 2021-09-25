# frozen_string_literal: true

FactoryBot.define do
  factory :character do
    account
    room
    name

    active_at { Time.current }

    trait :inactive do
      active_at { Character::ACTIVE_DURATION.ago - 1.minute }
    end
  end
end

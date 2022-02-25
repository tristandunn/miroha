# frozen_string_literal: true

FactoryBot.define do
  factory :spawn do
    room

    trait :monster do
      base { build(:monster) }
      entity { build(:monster) }
    end
  end
end

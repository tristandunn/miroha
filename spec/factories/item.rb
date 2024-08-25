# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name

    trait :room do
      owner { association(:room) }
    end
  end
end

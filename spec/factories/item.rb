# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name
    quantity { 1 }
    metadata { {} }

    trait :room do
      owner { association(:room) }
    end

    trait :stackable do
      metadata { { "stack_limit" => 5 } }
    end
  end
end

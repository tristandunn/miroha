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
      metadata { { "max_stack" => 5 } }
    end

    trait :consumable do
      metadata { { "max_stack" => 10, "consumable" => true } }
    end
  end
end

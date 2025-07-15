# frozen_string_literal: true

FactoryBot.define do
  factory :monster do
    room

    name
    experience { 5 }

    trait :aggressive do
      event_handlers { ["Monster::Aggression"] }
    end
  end
end

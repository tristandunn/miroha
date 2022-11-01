# frozen_string_literal: true

FactoryBot.define do
  factory :room do
    x           { Faker::Number.number }
    y           { Faker::Number.number }
    z           { Faker::Number.number }
    description { Faker::Lorem.sentence }

    trait :default do
      x { 0 }
      y { 0 }
      z { 0 }
    end
  end
end

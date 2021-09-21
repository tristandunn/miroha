# frozen_string_literal: true

FactoryBot.define do
  factory :room do
    x           { Faker::Number.number }
    y           { Faker::Number.number }
    z           { Faker::Number.number }
    description { Faker::Lorem.sentence }
  end
end

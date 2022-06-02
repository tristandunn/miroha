# frozen_string_literal: true

FactoryBot.define do
  factory :monster do
    room

    name
    experience { 5 }
  end
end

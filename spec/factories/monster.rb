# frozen_string_literal: true

FactoryBot.define do
  factory :monster do
    name
    experience { 5 }

    transient do
      room { nil }
    end

    after(:create) do |monster, evaluator|
      if evaluator.room.present?
        create(:spawn, :monster, base: monster.dup, entity: monster, room: evaluator.room)
      end
    end
  end
end

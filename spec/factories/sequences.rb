# frozen_string_literal: true

FactoryBot.define do
  sequence :email do
    Faker::Internet.email
  end

  sequence :password do
    Faker::Internet.password
  end
end

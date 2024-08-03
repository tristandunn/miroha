# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    aliases { I18n.t("account_form.default_aliases") }
    email
    password
  end
end

# frozen_string_literal: true

module RSpec
  module Helpers
    module Session
      module Controller
        def sign_in
          sign_in_as create(:account)
        end

        def sign_in_as(account)
          session[:account_id] = account.id
        end
      end

      module Feature
        def sign_in
          sign_in_as create(:account)
        end

        def sign_in_as(account)
          visit root_path
          click_link t("pages.index.sign_in")
          fill_in t("activemodel.attributes.account_form.email"),
                  with: account.email
          fill_in t("activemodel.attributes.account_form.password"),
                  with: account.password
          click_button t("sessions.new.submit")
        end

        def sign_out
          click_button t("characters.index.sign_out")
        end
      end

      RSpec.configure do |config|
        config.include Controller, type: :controller
        config.include Feature,    type: :feature
      end
    end
  end
end

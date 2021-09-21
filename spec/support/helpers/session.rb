# frozen_string_literal: true

module RSpec
  module Helpers
    module Session
      module Controller
        def sign_in
          sign_in_as create(:account)
        end

        def sign_in_as(record)
          if record.is_a?(Character)
            session[:account_id]   = record.account_id
            session[:character_id] = record.id
          else
            session[:account_id] = record.id
          end
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

        def sign_in_as_character(character)
          sign_in_as character.account
          click_button character.name
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

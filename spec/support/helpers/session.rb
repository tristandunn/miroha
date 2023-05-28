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
          visit root_path(account: account.id)
        end

        def sign_in_as_character(character = create(:character))
          visit root_path(account: character.account_id, character: character.id)

          expect(page).to have_css("#sidebar h1", text: character.name).and(
            have_css(
              "#streams turbo-cable-stream-source[connected]",
              count:   2,
              visible: :all
            )
          )
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

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

      RSpec.configure do |config|
        config.include Controller, type: :controller
      end
    end
  end
end

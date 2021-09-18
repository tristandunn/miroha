# frozen_string_literal: true

Rails.application.routes.draw do
  resources :accounts, only: %i(new create)
  resources :characters, only: %i(index)

  root to: "pages#index"
end

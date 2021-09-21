# frozen_string_literal: true

Rails.application.routes.draw do
  resources :accounts, only: %i(new create)

  resources :characters, only: %i(index new create) do
    collection do
      post :exit
    end

    member do
      post :select
    end
  end

  resource :sessions, only: %i(new create destroy)

  root to: "pages#index"
end

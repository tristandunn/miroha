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

  resources :commands, only: %i(create)
  resource  :sessions, only: %i(new create destroy)

  constraints(->(request) { Constraints::Game.matches?(request) }) do
    root to: "game#index", as: :game_root
  end

  root to: "pages#index"
end

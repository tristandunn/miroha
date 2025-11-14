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

  resource :world_editor, only: %i(show)

  namespace :api do
    resources :rooms, only: %i(show create update)
    resources :npcs, only: %i(create update destroy)
    resources :monsters, only: %i(create update destroy)
    resources :items, only: %i(create update destroy)
    resources :spawns, only: %i(create update destroy)
  end

  constraints(->(request) { Constraints::Game.matches?(request) }) do
    root to: "game#index", as: :game_root
  end

  get "/health", to: "health#index"

  root to: "pages#index"
end

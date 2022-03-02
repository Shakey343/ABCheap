Rails.application.routes.draw do
  devise_for :users
  root to: 'parameters#new'
  resources :parameters, only: [:create, :show, :new, :delete]
  resources :options, only: [:index, :show, :create]
end

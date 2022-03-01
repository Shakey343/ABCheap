Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :parameters, only: [:create, :show, :new, :delete]
  resources :options, only: [:index, :show, :create]
end

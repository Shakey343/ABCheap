Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#home'
  # devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, skip: [:session]

  resources :parameters, only: [:create, :show, :new, :delete]
  resources :bookings, only: [:create, :index, :show, :delete]
  # post 'booking', to: "bookings#create", as: :create_booking
  resources :users, only: [:show]

  # , :skip => [:sessions, :registrations]

  # devise_scope :user do
  #   get    "sign-in",  to: "devise/sessions#new",         as: :new_user_session
  #   post   "sign-in",  to: "devise/sessions#create",      as: :user_session
  #   delete "sign-out", to: "devise/sessions#destroy",     as: :destroy_user_session

  #   get    "sign-up",  to: "devise/registrations#new",    as: :new_user_registration
  #   post   "sign-up",  to: "devise/registrations#create", as: :user_registration
  # end
end

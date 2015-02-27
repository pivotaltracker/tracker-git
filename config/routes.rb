Rails.application.routes.draw do
  get 'github/authorize'
  get 'users/auth/github/callback/auth_app_callback', to: 'github#auth_app_callback'

  devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
    }

  devise_scope :user do
    get 'sign_in', to: redirect('/users/auth/github'), as: :new_user_session
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  authenticate :user do
    resources :repos do
      resources :pushes
    end
    get 'repos/:id/create_hook', to: 'repos#create_hook', as: :repo_create_hook

    resources :pushes
  end

  # unsecure and unauthencated actions:
  post 'pushes/receive', to: 'pushes#receive'
  root 'home#show'
end

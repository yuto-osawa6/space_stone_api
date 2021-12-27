Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]
  post 'social_auth/callback', to: 'social_auth#authenticate_social_auth_user' # this is th
  # mount_devise_token_auth_for 'User', at: 'auth'
  #  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
  #   omniauth_callbacks: 'overrides/omniauth_callbacks'
  # }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # devise_for :users
  namespace :api do
    namespace :v1 do
      # mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      #   omniauth_callbacks: 'api/v1/auth/omniauth_callbacks'
      # }
      # mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]
      # post 'social_auth/callback', to: 'social_auth#authenticate_social_auth_user' # this is the line where we add our routes
      resources :products do
        collection do
          # get "red"
          post "red"

          get "left"
        end
        resources :likes, only: [:create, :destroy] do
          collection do
            get "check"
          end
        end
        resources :scores, only:[:create, :update] do
        end
        resources :acsesses,only:[:create] do
        end
      end

      resources :mains,:only => :index do
        collection do
          get "search"
          get "genressearch"
          get "grid"
          get "setgrid"
        end
      end

      get "session_user", to:"session_user#login_check"

    end
  end
  # mount_devise_token_auth_for 'User', at: 'auth', controllers: {
  #   omniauth_callbacks: 'overrides/omniauth_callbacks'
  # }
end


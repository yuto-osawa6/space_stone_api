Rails.application.routes.draw do
  # mount_devise_token_auth_for 'User', at: 'auth'
  #  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
  #   omniauth_callbacks: 'overrides/omniauth_callbacks'
  # }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        omniauth_callbacks: 'api/v1/auth/omniauth_callbacks'
      }
      resources :products do
        collection do
          get "red"
          get "left"
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

    end
  end
  # mount_devise_token_auth_for 'User', at: 'auth', controllers: {
  #   omniauth_callbacks: 'overrides/omniauth_callbacks'
  # }
end


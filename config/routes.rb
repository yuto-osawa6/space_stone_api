Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
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
end


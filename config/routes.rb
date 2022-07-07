Rails.application.routes.draw do
  mount ActionCable.server => '/cable'


  # mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]
  mount_devise_token_auth_for 'User', at: 'auth', controllers: { omniauth_callbacks: "api/v1/auth/omniauth_callbacks" }
  post 'social_auth/callback', to: 'social_auth#authenticate_social_auth_user' # this is th

  get 'ota/index', to: 'otas#index' # this is th

  # mount_devise_token_auth_for 'User', at: 'auth'
  #  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
  #   omniauth_callbacks: 'overrides/omniauth_callbacks'
  # }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # devise_for :users

  namespace :api do
    namespace :v1 do
      get :health_check, to: 'health_check#index'
      resources :sessions,only:[:show]
      # mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      #   omniauth_callbacks: 'api/v1/auth/omniauth_callbacks'
      # }
      # mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]
      # post 'social_auth/callback', to: 'social_auth#authenticate_social_auth_user' # this is the line where we add our routes
      resources :products do
        collection do
          get "red"
          # post "red"
          get "left"
          get "edit1"
          get "product_episords"
          get "product_review"
          get "product_thread"
          get "product_thread_official"
        end
        member do
          get "seo"
          get "compare_score"
          get "compare_emotion"
          get "compare_tier"
        end
        resources :chats, only:[:create]

        resources :likes, only: [:create, :destroy] do
          collection do
            get "check"
          end
        end
        resources :scores, only:[:create, :update,:destroy] do
        end
        resources :acsesses,only:[:create] do
        end
        resources :reviews,only:[:create,:show,:update,:destroy] do
          collection do
            get "sort"
            get "second"
          end
          member do
            patch "update2"
          end
          resources :like_reviews,only:[:create,:destroy] do
            collection do
              get "check"
            end
          end
          resources :comment_reviews,only:[:create,:destroy] do
            # collection do
            #   get "check"
            # end
          end
        end
        resources :thereds,only:[:create,:show,:destroy] do
          collection do
            get "sort"
            get "second"
          end
          resources :like_threads,only:[:create,:destroy] do
            collection do
              get "check"
            end
          end
          resources :comment_threads,only:[:create,:destroy] do
          end

        end
      end

      resources :episords,only:[:create,:destroy] do
      end

      resources :users,only:[:show,:destroy] do
        collection do
          patch "setting"
          patch "background"
          patch "topimage"
          patch "overview"
          get "likes"
          get "scores"
          get "reviews"
          get "threads"
          get "likeGenres"
          get "mytiers"
          get "change_score_arrayies"
        end
        member do
          get "seo"
        end
      end

      resources :mains,:only => :index do
        collection do
          get "search"
          get "genressearch"
          get "grid"
          get "setgrid"
          get "castssearch"
          get "findcast"
          get "productSearch"
          get "monthduring"
          get "top100"
          get "studiossearch"
          get "emotion"
          get "weekliy_main"
          get "tier_main"
          get "user_search"
        end
      end

      resources :articles,:only => [:index,:show] do
        collection do
          get "associate"
          get "article_associate"
        end
      end

      resources :reviews,:only => [:index] do
        collection do
          # get "associate"
          # get "article_associate"
        end
      end

      resources :thereds,:only => [:index] do
        collection do
          # get "associate"
          # get "article_associate"
        end
      end
      # ------------------------------
      resources :janls,:only =>[:index,:create] do
      end
      resources :styles,:only =>[:index,:create] do
      end
      resources :casts,:only =>[:index,:create] do
      end
      resources :studios,:only =>[:index,:create] do
      end
      resources :staffs,:only =>[:index,:create] do
      end
      # 
      get "session_user", to:"session_user#login_check"
      get "ogp_images/:id", to:"ogps#show"

      namespace :comment do
        resources :like_comment_reviews,only:[:create,:destroy] do
            collection do
              get "check"
            end
        end
        resources :return_comment_reviews,only:[:index,:create,:destroy] do
          collection do
            post "returnreturn"
          end
          resources :like_return_comment_reviews,only:[:create,:destroy,:index] do
           
          end
        end

        resources :like_comment_threads,only:[:create,:destroy] do
          collection do
            get "check"
          end
        end
        resources :return_comment_threads,only:[:index,:create,:destroy] do
          collection do
            post "returnreturn"
          end
          resources :like_return_comment_threads,only:[:create,:destroy,:index] do
           
          end
        end

      end

      namespace :admin do
        resources :articles,only:[:create,:destroy,:update] do
          collection do
            post "uploadfile"
            get "productlist"
          end
        end
        resources :news,only:[:create,:destroy] do
        end
        resources :data_infos,only:[:index,:update]do
        end
        resources :products,only:[:index,:create,:destroy] do
          collection do
            get "setup"
            patch "published"
            patch "published_one"

          end
        end
      end
      resources :hashtags,only:[:create] do
      end
      # acsess
      namespace :acsesses do
        resources :acsess_reviews,only:[:create] do
        end
        resources :acsess_threads,only:[:create] do 
        end
        resources :acsess_articles,only:[:create] do
        end
      end
      namespace :mainblocks do
        resources :mains,only:[:show] do
          collection do
            get "trend"
            get "new_netflix"
            get "pickup"
            get "new_message"
            get "calendar"
            get "worldclass"
            get "toptens"
            get "populur_rt"
            get "ranking"
            post "vote"
            post "create_tier"
            get "user_this_season_tier"
            get "user_this_season_tier_user_page"
            get "get_user_tier_2"
            get "update_tier_list"
          end
        end
        resources :toptens,only:[:index] do
          collection do
            get "topten_l"
            get "topten_lm"
            get "topten_a"
            get "topten_am"
            get "topten_s"
            get "topten_sm"
            get "topten_r"
            get "topten_rm"
          end
        end
      end
    #----v1
    end
    #----ap1
  end
end




  class Api::V1::Auth::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
    # include ActionView::Rendering
    def redirect_callbacks
      super
    end
  
    def omniauth_success
      resource_class(User)
      super
      update_auth_header
      # return
      # redirect_to red_api_v1_products_path
    end
  
    def omniauth_failure
      super
    end
  
    protected
    def assign_provider_attrs(user, auth_hash)
      case auth_hash['provider']
        when 'twitter'
          # user.assign_attributes({
          #   nickname: auth_hash['info']['nickname'],
          #   name: auth_hash['info']['name'],
          #   image: auth_hash['info']['image'],
          #   email: auth_hash['info']['email']
          # })
          # render json: @resource, status: :ok
        when 'google_oauth2'
          user.assign_attributes({
            # nickname: auth_hash['info']['nickname'],
            nickname: "llllllllll",

            name: auth_hash['info']['name'],
            image: auth_hash['info']['image'],
            email: auth_hash['info']['email']
          })
          puts auth_hash
          # session[:userinfo] = request.env['omniauth.auth']['info']
          # session[:user_id]
          # render json: @resource, status: :ok
        # redirect_to red_api_v1_products_path

      else
        super
      end



      def render_data_or_redirect(message, data, user_data = {})
        if Rails.env.production?
          # if ['inAppBrowser', 'newWindow'].include?(omniauth_window_type)
          #   render_data(message, user_data.merge(data))
          # elsif auth_origin_url
          #   redirect_to DeviseTokenAuth::Url.generate(auth_origin_url, data.merge(blank: true))
          # else
          #   fallback_render data[:error] || 'An error occurred'
          # end
        else
          # @resource.credentials = auth_hash["credentials"]

          # わかりやすい様に開発時はjsonとして結果を返す
          # session[:userinfo] = request.env['omniauth.auth']['info']
          render json: {data: @resource, status: :ok,user_id:current_api_v1_user.id}
          
        end
      end



    end
  end


#   class Api::V1::Auth::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
#     def omniauth_success
#       get_resource_from_auth_hash
#       create_token_info
#       set_token_on_resource
#       create_auth_params

#       # ここは使わないのでコメントアウト
#       #if resource_class.devise_modules.include?(:confirmable)
#       #  # don't send confirmation email!!!
#       #  @resource.skip_confirmation!
#       #end

#       sign_in(:user, @resource, store: false, bypass: false)

#       # 動作確認用にユーザ情報を保存できたらjsonをそのまま返す処理
#       if @resource.save!
#         # update_token_authをつけることでレスポンスヘッダーに認証情報を付与できる。
#         update_auth_header
#         yield @resource if block_given?
#         render json: @resource, status: :ok
#       else
#         render json: { message: "failed to login" }, status: 500
#       end

#       # 本実装時はこちらを使用する
#       # @resource.save!
#       #       
#       # update_auth_header # これは自分で追加する
#       # yield @resource if block_given?
#       #
#       # render_data_or_redirect('deliverCredentials', @auth_params.as_json, @resource.as_json)

#     end

#     protected
#     def get_resource_from_auth_hash
#       # find or create user by provider and provider uid
#       @resource = resource_class.where({
#         uid:      auth_hash['uid'],
#         provider: auth_hash['provider']
#       }).first_or_initialize

#       if @resource.new_record?
#         @oauth_registration = true
#         # これが呼ばれるとエラーになるのでコメントアウトする
#         #set_random_password
#       end

#       # sync user info with provider, update/generate auth token
#       assign_provider_attrs(@resource, auth_hash)

#       # assign any additional (whitelisted) attributes
#       extra_params = whitelisted_params
#       @resource.assign_attributes(extra_params) if extra_params

#       @resource
#     end
#   puts "aaaaaaaaaaaaaaaaaaaaaaaaaa"
# end
  

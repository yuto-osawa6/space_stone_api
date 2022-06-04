class Api::V1::Auth::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  protect_from_forgery
  def redirect_callbacks
    super
  end

  def omniauth_success
    get_resource_from_auth_hash
    set_token_on_resource
    create_auth_params
    sign_in(:user, @resource, store: false, bypass: false)

    @resource.save!

    yield @resource if block_given?

    render_data_or_redirect('deliverCredentials', @auth_params.as_json, @resource.as_json)
  end

  def omniauth_failure
    if Rails.env.production?
      redirect_to "#{ENV['API_URL']}/403"
    else
      redirect_to "http://localhost:3000/403"
    end
  end
  protected

  def get_resource_from_auth_hash
    @resource = resource_class.where({
      uid:      auth_hash['uid'],
      provider: auth_hash['provider']
    }).first_or_initialize

    if @resource.new_record?
      @oauth_registration = true
    end
    assign_provider_attrs(@resource, auth_hash)
    extra_params = whitelisted_params
    @resource.assign_attributes(extra_params) if extra_params

    @resource
  end

  def assign_provider_attrs(user, auth_hash)
    if @resource.new_record? == false
      super
      return
    end
    case auth_hash['provider']
      when 'twitter'
      when 'google_oauth2'
        user.assign_attributes({
          nickname: auth_hash['info']['name'],
          image: auth_hash['info']['image'],
          email: auth_hash['info']['email']
        })
    else
      super
    end
  end



    def render_data_or_redirect(message, data, user_data = {})
      if Rails.env.production?
        # if ['inAppBrowser', 'newWindow'].include?(omniauth_window_type)
        #   render_data(message, user_data.merge(data))
        # elsif auth_origin_url
          # redirect_to DeviseTokenAuth::Url.generate("http://localhost:3000", data.merge(blank: true))
        # else
        #   fallback_render data[:error] || 'An error occurred'
        # end
      else
        if auth_origin_url
          redirect_to DeviseTokenAuth::Url.generate(ENV['API_URL_AUTH'], data.merge(aa: auth_origin_url))
        else
          redirect_to DeviseTokenAuth::Url.generate(ENV['API_URL_AUTH'], data.merge(aa: ENV['API_URL']))
        end
      end
    end
end

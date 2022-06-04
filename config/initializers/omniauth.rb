# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  # if Rails.env.production?
  #   # OmniAuth.config.full_host = 'https://api.meruplanet.com'
  # else
  #   # OmniAuth.config.path_prefix = '/omniauth'
  #   configure do |config|
  #     config.allowed_request_methods = [:get,:post]
  #   end
  # end
  configure do |config|
    config.allowed_request_methods = [:get,:post]
  end

  
  # OmniAuth.config.allowed_request_methods = [:post]
  # provider :github,        ENV['GITHUB_KEY'],   ENV['GITHUB_SECRET'],   scope: 'email,profile'
  # provider :facebook,      ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :google_oauth2, ENV['GOOGLE_KEY'],   ENV['GOOGLE_SECRET']
  # provider :apple,         ENV['APPLE_CLIENT_ID'], '', { scope: 'email name', team_id: ENV['APPLE_TEAM_ID'], key_id: ENV['APPLE_KEY'], pem: ENV['APPLE_PEM'] }

  # provider :twitter, ENV['TWITTER_KEY'],   ENV['TWITTER_SECRET']
  # OmniAuth.config.on_failure = Proc.new { |env|
  #   OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  # }
  
end
# OmniAuth.config.full_host = 'https://api.meruplanet.com'

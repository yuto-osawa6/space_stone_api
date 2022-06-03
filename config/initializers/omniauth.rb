# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.full_host = "https://api.meruplanet.com"
  end
  OmniAuth.config.allowed_request_methods = [:post, :get]

  # provider :github,        ENV['GITHUB_KEY'],   ENV['GITHUB_SECRET'],   scope: 'email,profile'
  # provider :facebook,      ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :google_oauth2, ENV['GOOGLE_KEY'],   ENV['GOOGLE_SECRET']
  # provider :apple,         ENV['APPLE_CLIENT_ID'], '', { scope: 'email name', team_id: ENV['APPLE_TEAM_ID'], key_id: ENV['APPLE_KEY'], pem: ENV['APPLE_PEM'] }

  # provider :twitter, ENV['TWITTER_KEY'],   ENV['TWITTER_SECRET']
  # OmniAuth.config.on_failure = Proc.new { |env|
  #   OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  # }
  
end

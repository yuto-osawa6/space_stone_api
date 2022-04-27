require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"
# require "graphql/client"
# require "graphql/client/http"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Goldfolten
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
   

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    
    # config.session_store :cookie_store, key: '_interslice_session'
    # config.middleware.use ActionDispatch::Cookies
    # config.middleware.use ActionDispatch::Session::CookieStore
    # config.middleware.use ActionDispatch::ContentSecurityPolicy::Middleware

    # config.session_store :cookie_store, key: '_session_mechaco'
    # config.middleware.use ActionDispatch::Cookies
    # config.middleware.use ActionDispatch::Session::CookieStore, config.session_options

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use ActionDispatch::ContentSecurityPolicy::Middleware

    # HTTP = GraphQL::Client::HTTP.new("https://api.annict.com/graphql") do
    #   def headers(context)
    #     # { "User-Agent": "My Client" }
    #     {"Authorization":"Bearer INosHFWhhSYBhtncuaNpok4WWmi73Jy3rINhIPIhu4Y"}
    #   end
    # end  
    # Schema = GraphQL::Client.load_schema(HTTP)
    # Client = GraphQL::Client.new(schema: Schema, execute: HTTP)

    # config.generators do |g|
    #   g.test_framework :rspec,
    #                    fixtures: false,
    #                    view_specs: false,
    #                    helper_specs: false,
    #                    routing_specs: false,
    #                    controller_specs: false,
    #                    request_specs: true
    #   g.fixture_replacement :factory_bot, dir: "spec/factories"
    # end
  
   
  end
end

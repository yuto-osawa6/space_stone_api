# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # allow do

  #   # origins "localhost:3000" # React側はポート番号3000で作るので「localhost:3000」を指定
  #   origins "http://192.168.3.5:3000"
  #   # origins "*"

  #   resource "*",

  #     headers: :any,
  #     methods: [:get, :post, :put, :patch, :delete, :options, :head],
  #     credentials: true
  # end


  allow do

    # origins "localhost:3000" # React側はポート番号3000で作るので「localhost:3000」を指定
    origins ['https://anime-tier.com', 'http://localhost:3000']
    # origins "http://192.168.3.5:3000"

    resource "*",
      headers: :any,
      expose: ["access-token", "expiry", "token-type", "uid", "client","X-CSRF-Token"],
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end

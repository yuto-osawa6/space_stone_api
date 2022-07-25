module AuthorizationSpecHelper
  def sign_in(user)
    # binding.pry
    post "/auth/sign_in/",
      params: { email: user[:email], password: "password" },
      as: :json

    return response.headers.slice('client', 'access-token', 'uid')
    # binding.pry
  end
end
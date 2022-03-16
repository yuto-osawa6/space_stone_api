HTTP = GraphQL::Client::HTTP.new("https://api.annict.com/graphql") do
  def headers(context)
    # { "User-Agent": "My Client" }
    {"Authorization":"Bearer INosHFWhhSYBhtncuaNpok4WWmi73Jy3rINhIPIhu4Y"}
  end
end  
Schema = GraphQL::Client.load_schema(HTTP)
Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
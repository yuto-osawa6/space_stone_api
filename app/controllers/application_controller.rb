class ApplicationController < ActionController::API
  before_action :first

  def first
    @styles = Style.all.includes(:products)
    @genres = Janl.all.includes(:products)

    # @styles.products.each do |a|

    # end
    # render json: { status: 201, message: "Hello World!",styles: @styles}

  end
end

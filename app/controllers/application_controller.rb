class ApplicationController < ActionController::API
  before_action :first

  def first
    @styles = Style.all
    @genre = Janl.all
    # render json: { status: 201, message: "Hello World!",styles: @styles}

  end
end

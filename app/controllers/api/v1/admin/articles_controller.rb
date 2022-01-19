class Api::V1::Admin::ArticlesController < ApplicationController


  def create
    @article = Article.new(create_params)
    if @article.save
      render json: {status:200}
    else
      render json: {status:500}
    end
  end

  def uploadfile
    puts params[:image]
    @image = Image.new(create_params2)
    if @image.save
      render json:@image,methods: [:image_url]
    else
      puts "aaa"
    end
  end

  # def  sum
  #   1 2

  # end

  private
  def create_params
    params.require(:article).permit(:content,:user_id)
  end

  def create_params2
    params.permit(:name,:image)
  end
end

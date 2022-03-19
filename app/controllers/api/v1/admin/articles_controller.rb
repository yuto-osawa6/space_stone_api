class Api::V1::Admin::ArticlesController < ApplicationController


  def create
    puts params[:article][:user_id] 
    @article = Article.new(create_params)
    if @article.save
      render json: {status:200}
    else
      render json: {status:500}
    end
  end

  def update
    puts params
    @article = Article.find(params[:id])
    puts "aaaaaaaa"
    if @article.update(create_params)
      render json: {status:200}
    else
      render json: {status:500}
    end
  end

  def destroy
    puts params
    begin
      @article = Article.find(params[:id])
      @article.destroy
      render json: {status:200}
    rescue => e
      puts e
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

  def productlist
    @products = Product.all
    render :productlist, formats: :json
  end

  # def  sum
  #   1 2

  # end

  private
  def create_params
    params.require(:article).permit(:content,:user_id,:title,:weekormonth,{product_ids:[]})
  end

  def create_params2
    params.permit(:name,:image)
  end
end

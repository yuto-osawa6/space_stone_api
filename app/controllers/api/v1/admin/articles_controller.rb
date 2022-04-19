class Api::V1::Admin::ArticlesController < ApplicationController


  def create
    @article = Article.new(create_params)
    if @article.save
      render json: {status:200}
    else
      render json: {status:500}
    end
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(create_params)
      render json: {status:200}
    else
      render json: {status:500}
    end
  end

  def destroy
    begin
      @article = Article.find(params[:id])
      @article.destroy
      render json: {status:200}
    rescue => e
      render json: {status:500}
    end
  end

  def uploadfile
    # notest nouse (quillの画像処理)
    @image = Image.new(create_params2)
    if @image.save
      render json:@image,methods: [:image_url]
    else
    end
  end

  def productlist
    # notest
    @products = Product.all
    render :productlist, formats: :json
  end

  private
  def create_params
    params.require(:article).permit(:content,:user_id,:title,:weekormonth,{product_ids:[]})
  end

  def create_params2
    params.permit(:name,:image)
  end
end

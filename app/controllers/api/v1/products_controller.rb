class Api::V1::ProductsController < ApplicationController

  def left
    @styles = Style.all.includes(:products)
    @genres = Janl.all.includes(:products)

    render :left,formats: :json

  end


 

  def index
    # @products = Product.all.where(finished:0).limit(30)

    @q = Product.ransack(params[:q])
    @products = @q.result.where(finished:0).limit(30)
  
    render :index,formats: :json

  end

  def search()
    puts @grid
    # @q = Product.ransack(params[:q])
    # @search_title = params[:q][:"title_cont"]

   
    # @categories = params[:q][:janls_id_in].drop(1)

    # @genres = Janl.where(id:@categories)

    # pushIdArrays = []
 
    # unless @categories.length < 2
    #   @matchAllCategories = JanlProduct.where(janl_id: @categories).select(:product_id).group(:product_id).having('count(product_id) = ?', @categories.length)
    #   categoryRestaurantIds = @matchAllCategories.map(&:product_id)
    #   pushIdArrays.push(categoryRestaurantIds)
    # end
    # @tags = params[:q][:styles_id_eq]
    # @style_names = Style.where(id:@tags)


    # unless @tags.empty?
    #   matchAllTags = StyleProduct.where(style_id: @tags).select(:product_id).group(:product_id).having('count(product_id) = ?', @tags.length)
    #   tagRestaurantIds = matchAllTags.map(&:product_id)
    #   pushIdArrays.push(tagRestaurantIds)
     
    # end

    # if pushIdArrays.length > 1

    #     filteredIdArray = pushIdArrays.flatten.group_by{|e| e}.select{|k,v| v.size > 1}.map(&:first)
        
    #     @products = @q.result(distinct: true).where(id:filteredIdArray).where(finished:0).limit(30)

    #   elsif pushIdArrays.length == 1
    #     print "ccccccccccccc"
        
    #     @products = @q.result(distinct: true).where(id:pushIdArrays).where(finished:0).limit(30)

    #   else
    #     @products = @q.result(distinct: true).where(finished:0).limit(30)
    #     print "ccaaa"
    #     # @products_styles = @products.styles.name

    # end
  end

    # def grid_component
    #   @@grid = params[:grid]


    # end

  def red
    @products = Product.all.where(finished:0).limit(30)
    render json: { status: 200, message: "Hello World!43",products: @products}
    
  end

end

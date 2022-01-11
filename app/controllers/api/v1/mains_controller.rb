class Api::V1::MainsController < ApplicationController
  def index
    # @q = Product.ransack(params[:q])
    # @products = @q.result.where(finished:0).limit(30)
    # render :index,formats: :json

    # doneyet newcontentsとdelivery_startが両方入っている問題
    range = Date.yesterday.beginning_of_day..Date.yesterday.end_of_day
    @new_netflix = Product.where("delivery_start <= ?", Date.today).or(Product.where(new_content:true)).order(delivery_start:"desc")
    # @decision_news = Product.where(decision_news:true)
    @decision_news = Newmessage.all.order(updated_at:"desc")
    @pickup = Product.where(pickup:true)
    # @delivery_end = Product.where("end_day LIKE ?", "%配信終了%")
    @delivery_end = Product.where("length(delivery_end) > 0")
    
    # @delivery_start = Product.where("end_day LIKE?","%配信開始%")
    @delivery_start = Product.where("length(delivery_start) > 0")

    # 世界的に人気な映画 TV
    @period = Period.order(created_at:"desc").limit(1)
    @topten = @period[0].toptens.where.not(product_id:nil)
    # @topten = @period[0].toptens.where.not(product_id:nil)
    # @topten = @period[0].toptens.where.not(product_id:nil)


    # puts @period[].id
    @topten.each do |a|
      puts a.product.title
      puts a.product.description
    end


    # puts @delivery_end.length
    # puts @delivery_start.length
    # puts @renn = @delivery_start - @delivery_start2
    # puts @renn[0].id

    # puts @new_netflix.ids
    render :index,formats: :json

  end 
  def search
    # puts @grid
    @q = Product.ransack(params[:q])
    # @search_title = params[:q][:"title_cont"]
    # @products = @q.result(distinct: true).where(finished:0).limit(30)
    # render :search,formats: :json


   
    @categories = params[:q][:janls_id_in].drop(1)

    @genres = Janl.where(id:@categories)

    pushIdArrays = []
 
    unless @categories.length < 2
      @matchAllCategories = JanlProduct.where(janl_id: @categories).select(:product_id).group(:product_id).having('count(product_id) = ?', @categories.length)
      categoryRestaurantIds = @matchAllCategories.map(&:product_id)
      pushIdArrays.push(categoryRestaurantIds)
    end
    @tags = params[:q][:styles_id_eq]
    @style_names = Style.where(id:@tags)


    unless @tags.empty?
      matchAllTags = StyleProduct.where(style_id: @tags).select(:product_id).group(:product_id).having('count(product_id) = ?', @tags.length)
      tagRestaurantIds = matchAllTags.map(&:product_id)
      pushIdArrays.push(tagRestaurantIds)
     
    end

    if pushIdArrays.length > 1

        filteredIdArray = pushIdArrays.flatten.group_by{|e| e}.select{|k,v| v.size > 1}.map(&:first)
        
        @products = @q.result(distinct: true).where(id:filteredIdArray).where(finished:0).includes(:styles,:janls).page(params[:page]).per(50)

      elsif pushIdArrays.length == 1
        # print "ccccccccccccc"
        
        @products = @q.result(distinct: true).where(id:pushIdArrays).where(finished:0).includes(:styles,:janls).page(params[:page]).per(50)

      else
        @products = @q.result(distinct: true).where(finished:0).includes(:styles,:janls).page(params[:page]).per(50)
        # @products_styles = @products.styles.name

    end
    puts "lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll"
    puts @products.total_pages

    render :search,formats: :json
  end

  def genressearch
    genres_title = params[:data]
    @genres = Janl.where("name LIKE ?", "%#{genres_title}%")
    # puts @genres

    render :genressearch,formats: :json
  end

  def grid
    if params[:grid] === ""
      if session[:grid_id]
        @grid = session[:grid_id]
        # puts "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
        # puts "ggggggggggggggggggggggggggggggggggggggggggggggggggg"

        # redirect_to red_api_v1_products_path
        #  puts "ggggggggggggggggggggggggggggggggggggggggggggggggggg"
      else
        puts session[:grid_id]
        puts session
        session[:grid_id] = "01"
        @grid = session[:grid_id]
        puts session
        puts session[:grid_id]
        puts "hhggggggggggggggggggggggggggggggggggggggggggggggggggggggggggghhhhhhhh"

      end

    else
      session[:grid_id] = params[:grid]
      @grid = session[:grid_id]
      # aaaaa(a)
      # puts @instance
      # puts @grid
      # search()
      # aaaaa($grid)
      # render :grid,formats: :json
      puts session
      puts session[:grid_id]
      puts "lllllllllllllllllllllllllllllllllllllllllllllllllllllll"
    end
    render :grid,formats: :json
    # render json: @grid

  end

  # def setgrid
  #   if session[:grid_id]
  #     @grid = session[:grid_id]
  #     puts "aaa"
  #   else 
  #     session[:grid_id] = "01"
  #     @grid = session[:grid_id]
  #     render :grid, formats: :json
  #     puts "bbb"
  #   end
  # end
end

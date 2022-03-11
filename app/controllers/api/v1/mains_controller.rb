class Api::V1::MainsController < ApplicationController
  def index
    # # doneyet newcontentsとdelivery_startが両方入っている問題
    # range = Date.yesterday.beginning_of_day..Date.yesterday.end_of_day
    # @new_netflix = Product.where("delivery_start <= ?", Date.today).or(Product.where(new_content:true)).order(delivery_start:"desc")
    # # @decision_news = Product.where(decision_news:true)
    # @decision_news = Newmessage.all.order(updated_at:"desc")
    # @pickup = Product.where(pickup:true)
    # # @delivery_end = Product.where("end_day LIKE ?", "%配信終了%")
    # @delivery_end = Product.where("length(delivery_end) > 0")
    
    # # @delivery_start = Product.where("end_day LIKE?","%配信開始%")
    # @delivery_start = Product.where("length(delivery_start) > 0")

    # # 世界的に人気な映画 TV
    # @period = Period.order(created_at:"desc").limit(1)
    # @topten = @period[0].toptens.where.not(product_id:nil)

    # した消さない productテーブルから関連モデルのgroupかした情報を持ってくる方法。
    # @like_topten_month = Product.joins(:likes).where(updated_at:from...to).group("product_id").order(Arel.sql('count(product_id) DESC')).limit(10)
    # @like_topten_all = Product.joins(:likes).group("product_id").order(Arel.sql('count(product_id) DESC')).limit(10)
   
    # @score_topten_month = Acsess.where(date: from...to).order(count: "DESC").limit(10)
    # @score_topten_all = Product.joins(:scores).group("product_id").order(Arel.sql('avg(value) DESC')).limit(10)

    # @acsess_topten_month = Product.joins(:acsesses).where(date:Time.current.prev_month.beginning_of_month...to).order(count: "DESC").limit(10)
    # @acsess_topten_all = Product.joins(:acsesses).group("product_id").order(Arel.sql('sum(count) DESC')).limit(10)

    # puts @acsess_topten_month = Product.joins(:acsesses)
    # puts @like_topten_month.ids
    # puts @like_topten_all.ids
    # puts @score_topten_month.ids
    # puts @score_topten_all.ids
    # # puts @acsess_topten_month.ids
    # puts @acsess_topten_all.ids

    
    # top10
    # now = Time.current 
    # from = now.prev_month
    # to = now
    # @like_topten_month =  Like.where(updated_at: from...to).group(:product_id).order("count_all DESC").limit(10).count
    # @like_topten_all =  Like.group(:product_id).order("count_all DESC").limit(10).count
    # @score_topten_month = Score.where(updated_at: from...to).group(:product_id).having('count(*) > ?', 0).order('average_value DESC').limit(10).average(:value)
    # @score_topten_all = Score.group(:product_id).having('count(*) > ?', 0).order('average_value DESC').limit(10).average(:value)
    # @acsess_topten_month = Acsess.where(date: Time.current.prev_month.beginning_of_month...to).group(:product_id).order("sum_count DESC").limit(10).sum(:count)
    # @acsess_topten_all = Acsess.group(:product_id).order('sum_count DESC').limit(10).sum(:count)
   
    
    # tags
    @year = Year.all.order(year:"asc")
    # doneyet_completion length
    # @season = Season.order(season_number:"asc")
    @season = Kisetsu.where(id:2...6)
    #  # doneyet_2 3年間データーをどうするか、一年間に設定
    # from = Date.today.ago(3.years)
    # to = Date.today
    @tags = MonthDuring.all.order(month:"asc").limit(12)

    render :index,formats: :json

  end 
  def search
    @q = Product.ransack(params[:q])

    # puts Product.where("delivery_end >= ?", params[:q][:delivery_end_qteq]).ids
    puts params[:q][:sort_emotion_id].present?
   
    @categories = params[:q][:janls_id_in].drop(1)
    @casts = params[:q][:casts_id_in].drop(1)
    @studios = params[:q][:studios_id_in].drop(1)

    # @genres = Janl.where(id:@categories)

    pushIdArrays = []
 
    unless @categories.length < 2
      @matchAllCategories = JanlProduct.where(janl_id: @categories).select(:product_id).group(:product_id).having('count(product_id) = ?', @categories.length)
      categoryRestaurantIds = @matchAllCategories.map(&:product_id)
      puts @matchAllCategories
      pushIdArrays.push(categoryRestaurantIds)
    end

    unless  @casts.length < 2
      @matchAllCasts = CastProduct.where(cast_id: @casts).select(:product_id).group(:product_id).having('count(product_id) = ?', @casts.length)
      # puts @matchAllCasts
      castsIds = @matchAllCasts.map(&:product_id)
      pushIdArrays.push(castsIds)
    end

    unless  @studios.length < 2
      @matchAllStudios = StudioProduct.where(studio_id: @studios).select(:product_id).group(:product_id).having('count(product_id) = ?', @studios.length)
      # puts @matchAllCasts
      studiosIds = @matchAllStudios.map(&:product_id)
      pushIdArrays.push(studiosIds)
    end



    @tags = params[:q][:styles_id_eq]
    @style_names = Style.where(id:@tags)


    unless @tags.empty?
      matchAllTags = StyleProduct.where(style_id: @tags).select(:product_id).group(:product_id).having('count(product_id) = ?', @tags.length)
      tagRestaurantIds = matchAllTags.map(&:product_id)
      # print tagRestaurantIds
      pushIdArrays.push(tagRestaurantIds)
     
    end

    if params[:q][:sort_emotion_id].present?
      # puts Product.all.left_outer_joins(:review_emotions).group("products.id").order(Arel.sql("sum(CASE WHEN emotion_id = 1 THEN 1 ELSE 0 END)/count(emotion_id) desc")).ids
      if pushIdArrays.length > 1
        filteredIdArray = pushIdArrays.flatten.group_by{|e| e}.select{|k,v| v.size > 1}.map(&:first)
        @products = @q.result(distinct: true).where(id:filteredIdArray).where(finished:0).includes(:styles,:janls,:scores).left_outer_joins(:review_emotions).group("products.id").order(Arel.sql("sum(CASE WHEN emotion_id = #{params[:q][:sort_emotion_id]} THEN 1 ELSE 0 END)/count(emotion_id) desc")).order(created_at: :desc).page(params[:page]).per(50)
      elsif pushIdArrays.length == 1
          @products = @q.result(distinct: true).where(id:pushIdArrays).where(finished:0).includes(:styles,:janls,:scores).left_outer_joins(:review_emotions).group("products.id").order(Arel.sql("sum(CASE WHEN emotion_id = #{params[:q][:sort_emotion_id]} THEN 1 ELSE 0 END)/count(emotion_id) desc")).order(created_at: :desc).page(params[:page]).per(50)
      else
          @products = @q.result(distinct: true).where(finished:0).includes(:styles,:janls,:scores).left_outer_joins(:review_emotions).group("products.id").order(Arel.sql("sum(CASE WHEN emotion_id = #{params[:q][:sort_emotion_id]} THEN 1 ELSE 0 END)/count(emotion_id) desc")).order(created_at: :desc).page(params[:page]).per(50)

      end


    else

      if pushIdArrays.length > 1
          filteredIdArray = pushIdArrays.flatten.group_by{|e| e}.select{|k,v| v.size > 1}.map(&:first)
          @products = @q.result(distinct: true).where(id:filteredIdArray).where(finished:0).includes(:styles,:janls,:scores).order(new_content: :desc).order(pickup: :desc).page(params[:page]).per(50)
      elsif pushIdArrays.length == 1
          @products = @q.result(distinct: true).where(id:pushIdArrays).where(finished:0).includes(:styles,:janls,:scores).order(new_content: :desc).order(pickup: :desc).page(params[:page]).per(50)
      else
          @products = @q.result(distinct: true).where(finished:0).includes(:styles,:janls,:scores).order(new_content: :desc).order(pickup: :desc).page(params[:page]).per(50)

      end
    end

    render :search,formats: :json
  end

  def genressearch
    genres_title = params[:data]
    @genres = Janl.where("name LIKE ?", "%#{genres_title}%")
    # puts @genres

    render :genressearch,formats: :json
  end

  def castssearch
    genres_title = params[:data]
    @casts = Cast.where("name LIKE ?", "%#{genres_title}%")
    render json:{casts:@casts}
  end

  def studiossearch
    genres_title = params[:data]
    @studios = Studio.where("company LIKE ?", "%#{genres_title}%")
    render json:{studios:@studios}
  end


  def productSearch
    @products = Product.where("title LIKE ?", "%#{params[:product_title]}%")
    render json:{products:@products}
  end


  def findcast
    @cast = Cast.find(params[:id])
    render json:{cast:@cast}
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

  def monthduring
    @month = MonthDuring.all.order(created_at: :desc).limit(12)
    render json:{month: @month}
  end



  def top100
    # @month = 
    case params[:genre]
    when "1" then
      if params[:month].present?
        from = params[:month].to_date
        to = from.end_of_month
        @product =  Product.left_outer_joins(:likes).includes(:styles,:janls,:scores,:likes).where(likes:{updated_at: from...to}).group("products.id").order(Arel.sql('count(product_id) DESC')).limit(100)
      else
        to = Time.current
        from = to.ago(5.years)
        @product =  Product.left_outer_joins(:likes).includes(:styles,:janls,:scores,:likes).where(likes:{updated_at: from...to}).group("products.id").order(Arel.sql('count(product_id) DESC')).limit(100)
      end
      
    when "2" then
      if params[:month].present?
        from = params[:month].to_date
        to = from.end_of_month
        @product =  Product.left_outer_joins(:scores).includes(:styles,:janls,:scores,:likes).where(scores:{updated_at: from...to}).group("products.id").order(Arel.sql('avg(value) DESC')).limit(100)
      else
        to = Time.current
        from = to.ago(5.years)
        @product =  Product.left_outer_joins(:scores).includes(:styles,:janls,:scores,:likes).where(scores:{updated_at: from...to}).group("products.id").order(Arel.sql('avg(value) DESC')).limit(100)
      end

    when "3" then
      if params[:month].present?
        from = params[:month].to_date
        to = from.end_of_month
        @product = Product.left_outer_joins(:acsesses).includes(:styles,:janls,:scores,:acsesses).where(acsesses:{date:from...to}).group("products.id").order(Arel.sql('sum(count) DESC')).limit(100)

      else
        to = Time.current
        from = to.ago(5.years)
        # @productids = Product.joins(:acsesses).group("products.id").order(Arel.sql('sum(count) DESC')).limit(100).ids
        @product = Product.left_outer_joins(:acsesses).includes(:styles,:janls,:scores,:acsesses).where(acsesses:{date:from...to}).group("products.id").order(Arel.sql('sum(count) DESC')).limit(100)
        
      end
    when "4" then
      if params[:month].present?
        from = params[:month].to_date
        to = from.end_of_month
        @product = Product.left_outer_joins(:reviews).includes(:styles,:janls,:scores,:reviews).where(reviews:{updated_at:from...to}).group("products.id").order(Arel.sql('count(products.id) DESC')).limit(100)
      else
        to = Time.current
        from = to.ago(5.years)
        @product = Product.left_outer_joins(:reviews).includes(:styles,:janls,:scores,:reviews).where(reviews:{updated_at:from...to}).group("products.id").order(Arel.sql('count(products.id) DESC')).limit(100)
      end
    when "5" then
      if params[:month].present?
        from = params[:month].to_date
        to = from.end_of_month
        @product = Product.left_outer_joins(:thereds).includes(:styles,:janls,:scores,:thereds).where(thereds:{updated_at:from...to}).group("products.id").order(Arel.sql('count(products.id) DESC')).limit(100)
      else
        to = Time.current
        from = to.ago(5.years)
        @product = Product.left_outer_joins(:thereds).includes(:styles,:janls,:scores,:thereds).where(thereds:{updated_at:from...to}).group("products.id").order(Arel.sql('count(products.id) DESC')).limit(100)
      end

    else

      if params[:month].present?
        from = params[:month].to_date
        to = from.end_of_month
        @product =  Product.left_outer_joins(:likes).includes(:styles,:janls,:scores,:likes).where(likes:{updated_at: from...to}).group("products.id").order(Arel.sql('count(product_id) DESC')).limit(100)
      else
        to = Time.current
        from = to.ago(5.years)
        @product =  Product.left_outer_joins(:likes).includes(:styles,:janls,:scores,:likes).where(likes:{updated_at: from...to}).group("products.id").order(Arel.sql('count(product_id) DESC')).limit(100)
      end

    end
    render :top100, formats: :json
  end

  def emotion
    emotion = Emotion.all
    render json:{emotionList:emotion}
  end

  def weekliy_main
    current_time = Time.current.ago(6.hours).prev_week(:monday).prev_week(:monday).since(1.hours)
    three_month_ago = current_time.ago(3.month).ago(1.hours)
    @week_all = Week.where(week:three_month_ago...current_time).includes(products: :episords).includes(products: :weeklyrankings)

    render :weekliy_main, formats: :json
  end

  def tier_main
    kisetsu_ids = [5,2,3,4]
    @tierGroup = TierGroup.all.includes(:year,:kisetsu).includes(tiers: :product).order(Arel.sql("year.year desc")).order(Arel.sql("FIELD(kisetsu_id, #{kisetsu_ids.join(',')})")).page(params[:page_year]).per(1)
    @tierGroupLength = TierGroup.all.size
    render :tier_main,formats: :json
  end

end

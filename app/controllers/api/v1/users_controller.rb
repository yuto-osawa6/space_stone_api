class Api::V1::UsersController < ApplicationController
  def setting
    @user = User.find(params[:user_id])
    if @user.update(update_params)
      render json:{status:500,message:"nicknameを更新しました。",user:@user}
    else
      render json:{status:500}
    end
  end

  def background
    @user = User.find(params[:user_id])
    # @user.bacgroundImg = params[:backgroundImage]
    if @user.update(background_params2)
      render json:{status:200,message:"背景画像を更新しました。",background:@user.image_url}
    else
      render json:{status:500}
    end
  end

  def overview
    @user = User.find(params[:user_id])
    if @user.update(overview_params)
      render json:{status:200,message:"概要を更新しました。",overview:@user.overview}
    else
      render json:{status:500}
    end
  end

  # def background
  #   @user = User.find(params[:user_id])
  #   # @user.bacgroundImg = params[:backgroundImage]
  #   if @user.update(background_params)

  #   else

  #   end
  # end

  def show
    @pss = {
      "10"=> 0,
      "20"=> 0,
      "30"=> 0,
      "40"=> 0,
      "50"=> 0,
      "60"=> 0,
      "70"=> 0,
      "80"=> 0,
      "90"=> 0,
      "100"=> 0,
    } 

    @user = User.find(params[:user_id])

    il = @user.liked_products.joins(:janl_products).group(:janl_id).order("count(janl_id) desc").count.keys
    # Product.janls
    @genre = Janl.where(id:il).order([Arel.sql('field(id, ?)'), il]).limit(4)

    # score statics
    @score = @user.scores.group(:value).count
    @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    @score_array = []
    @pss.map{|key,value|@score_array.push(@pss[key])}

    # like
    @like = @user.liked_products.limit(4)
    # emotion
    @emotion = @user.emotions.group("emotions.id").order(Arel.sql("count(emotion_id) desc"))
    @emotion_count = @user.emotions.group("emotions.id").order(Arel.sql("count(emotion_id) desc")).size
    @emotion_all_count = @user.emotions.size

    # score emotion
    @score_emotions_ids = @user.scores_products.group("scores.id").having('sum(scores.value) > ?', 80).ids
    @score_emotion = @user.emotions.where(review_emotions:{product_id:[@score_emotions_ids]}).group("emotions.id").order(Arel.sql("count(emotion_id) desc"))
    @score_emotion_count = @user.emotions.where(review_emotions:{product_id:[@score_emotions_ids]}).group("emotions.id").order(Arel.sql("count(emotion_id) desc")).size
    @score_emotion_all_count = @user.emotions.where(review_emotions:{product_id:[@score_emotions_ids]}).size

    # tier
    user_this_season_tier(params[:user_id])

    render :show, formats: :json
  end

  def user_this_season_tier(user_id)
    @time = Time.current
    case @time.month
    when 1,2,3 then
      @kisetsu_name = "冬"
    when 4,5,6 then
      @kisetsu_name = "春"
    when 7,8,9 then
      @kisetsu_name = "夏"
    when 10,11,12 then
      @kisetsu_name = "秋"
    end
    
   
    # @yearSeason = "#{@time.year} #{@kisetsu_name}"

    @year = Year.find_by(year:"#{@time.year}-01-01")
    @kisetsu = Kisetsu.find_by(name:@kisetsu_name)
    group = TierGroup.find_by(year_id:@year.id,kisetsu_id:@kisetsu.id)
    if group.present?
      @tier_group =  group.tiers.where(user_id:user_id).includes(:product)
    else

    end
    # add
    # @current_season = "#{@time.year} #{@kisetsu.name}"
    # @new_netflix = Product.left_outer_joins(:acsesses,:year_season_seasons,:year_season_years).includes(:styles,:janls,:tags,:scores).where(year_season_years:{year:"#{@time.year}-01-01"}).where(year_season_seasons:{id:@kisetsu}).group("products.id").order(Arel.sql('sum(count) DESC'))
  end

  def likes
    @user = User.find(params[:user_id])
    @product = @user.liked_products.page(params[:page]).per(2)
    @length = @user.liked_products.count
    # render json:{product: @product,length: @length}
    render :likes,formats: :json
  end

  def likeGenres
    @user = User.find(params[:user_id])

    il = @user.liked_products.joins(:janl_products).group(:janl_id).order("count(janl_id) desc").count.keys
    # Product.janls
    @genres = Janl.where(id:il).order([Arel.sql('field(id, ?)'), il])
    render json:{genres:@genres}
  end

  def scores
    @index = params[:score_index]
    @user = User.find(params[:user_id])
    case @index
    when "0" then
      @products = Product.joins(:scores).where(scores:{user_id:@user.id}).order(value: :desc).page(params[:page]).per(2)
      @your_score = @user.scores.where(product_id:@products.ids).order(value: :desc)
    when "1" then
      @products = Product.joins(:scores).where(scores:{user_id:@user.id}).order(all: :desc).page(params[:page]).per(2)
      @your_score = @user.scores.where(product_id:@products.ids).order(all: :desc)
    when "2" then
      @products = Product.joins(:scores).where(scores:{user_id:@user.id}).order(story: :desc).page(params[:page]).per(2)
      @your_score = @user.scores.where(product_id:@products.ids).order(story: :desc)
    when "3" then
      @products = Product.joins(:scores).where(scores:{user_id:@user.id}).order(animation: :desc).page(params[:page]).per(2)
      @your_score = @user.scores.where(product_id:@products.ids).order(animation: :desc)
    when "4" then
      @products = Product.joins(:scores).where(scores:{user_id:@user.id}).order(performance: :desc).page(params[:page]).per(2)
      @your_score = @user.scores.where(product_id:@products.ids).order(performance: :desc)
    when "5" then
      @products = Product.joins(:scores).where(scores:{user_id:@user.id}).order(music: :desc).page(params[:page]).per(2)
      @your_score = @user.scores.where(product_id:@products.ids).order(music: :desc)
    when "6" then
      @products = Product.joins(:scores).where(scores:{user_id:@user.id}).order(character: :desc).page(params[:page]).per(2)
      @your_score = @user.scores.where(product_id:@products.ids).order(character: :desc)
    end
    @length = @user.scores_products.count
    render :scores, formats: :json
  end

  def reviews
    @user = User.find(params[:user_id])
    if params[:product_id].present?
      if params[:emotion].present?
        if params[:select_sort].present?
          case params[:select_sort]
          when "0" then
            @reviews = @user.reviews.includes(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(product_id:params[:product_id]).includes(:product).left_outer_joins(:like_reviews,:review_emotions).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
            @review_length = @user.reviews.includes(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(product_id:params[:product_id]).size
          when "1" then
            @reviews = @user.reviews.includes(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(product_id:params[:product_id]).includes(:product).left_outer_joins(:acsess_reviews,:review_emotions).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
            @review_length = @user.reviews.includes(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(product_id:params[:product_id]).size
          end
        else
        @reviews = @user.reviews.includes(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(product_id:params[:product_id]).includes(:product).left_outer_joins(:review_emotions).order(episord_id: :asc).page(params[:page]).per(2)
        @review_length = @user.reviews.includes(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).where(product_id:params[:product_id]).size
        end
      else
        if params[:select_sort].present?
          case params[:select_sort]
          when "0" then
            @reviews = @user.reviews.where(product_id:params[:product_id]).includes(:product).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
            @review_length = @user.reviews.where(product_id:params[:product_id]).size
          when "1" then
            @reviews = @user.reviews.where(product_id:params[:product_id]).includes(:product).left_outer_joins(:acsess_reviews).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
            @review_length = @user.reviews.where(product_id:params[:product_id]).size
          end
        else
        @reviews = @user.reviews.where(product_id:params[:product_id]).includes(:product).order(episord_id: :asc).page(params[:page]).per(2)
        @review_length = @user.reviews.where(product_id:params[:product_id]).size
        end
      end
    else
      if params[:emotion].present?
        if params[:select_sort].present?
          case params[:select_sort]
          when "0" then
            @reviews = @user.reviews.includes(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).left_outer_joins(:like_reviews,:review_emotions).includes(:product).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
            @review_length = @user.reviews.includes(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).size
          when "1" then
            @reviews = @user.reviews.includes(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).left_outer_joins(:acsess_reviews,:review_emotions).includes(:product).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
            @review_length = @user.reviews.includes(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).size
          end
        else
        @reviews = @user.reviews.includes(:review_emotions).left_outer_joins(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).order(created_at: :desc).includes(:product).page(params[:page]).per(2)
        @review_length = @user.reviews.includes(:review_emotions).where(review_emotions:{emotion_id:params[:emotion]}).size
        end
      else
        if params[:select_sort].present?
          case params[:select_sort]
          when "0" then
            @reviews = @user.reviews.left_outer_joins(:like_reviews).includes(:product).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
            @review_length = @user.reviews.size
          when "1" then
            @reviews = @user.reviews.left_outer_joins(:acsess_reviews).includes(:product).group("reviews.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
            @review_length = @user.reviews.size
          end
        else
        @reviews = @user.reviews.order(created_at: :desc).includes(:product).page(params[:page]).per(2)
        @review_length = @user.reviews.size
        end
      end
    end
    render :reviews,formats: :json
  end

  def threads
    @user = User.find(params[:user_id])
    if params[:product_id].present?
        if params[:select_sort].present?
          case params[:select_sort]
          when "0" then
            @reviews = @user.thereds.where(product_id:params[:product_id]).left_outer_joins(:like_threads).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
            @review_length = @user.thereds.where(product_id:params[:product_id]).size
          when "1" then
            @reviews = @user.thereds.where(product_id:params[:product_id]).left_outer_joins(:acsess_threads).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
            @review_length = @user.thereds.where(product_id:params[:product_id]).size
          end
        else
        @reviews = @user.thereds.where(product_id:params[:product_id]).order(created_at: :desc).includes(:product).page(params[:page]).per(2)
        @review_length = @user.thereds.where(product_id:params[:product_id]).count
        end
      else
        if params[:select_sort].present?
          case params[:select_sort]
          when "0" then
            @reviews = @user.thereds.left_outer_joins(:like_threads).group("thereds.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).order("count(goodbad) desc").page(params[:page]).per(2)
            @review_length = @user.thereds.size
          when "1" then
            @reviews = @user.thereds.left_outer_joins(:acsess_threads).group("thereds.id").order(Arel.sql("sum(count) desc")).page(params[:page]).per(2)
            @review_length = @user.thereds.size
          end
        else
        @reviews = @user.thereds.order(created_at: :desc).includes(:product).page(params[:page]).per(2)
        @review_length = @user.thereds.count
        end
    end
    # render :
    render :reviews,formats: :json
  end

  def mytiers
    @user = User.find(params[:user_id])
    kisetsu_ids = [5,2,3,4]
    @tierGroup = TierGroup.all.includes(:year,:kisetsu).includes(tiers: :product).order(Arel.sql("year.year desc")).order(Arel.sql("FIELD(kisetsu_id, #{kisetsu_ids.join(',')})")).page(params[:page]).per(1)
    @tierGroupLength = TierGroup.all.size
    render :mytiers,formats: :json
  end

  def change_score_arrayies
    @user = User.find(params[:user_id])
    @pss = {
      "10"=> 0,
      "20"=> 0,
      "30"=> 0,
      "40"=> 0,
      "50"=> 0,
      "60"=> 0,
      "70"=> 0,
      "80"=> 0,
      "90"=> 0,
      "100"=> 0,
    } 

    case params[:index_number]
    when "0" then
      @score = @user.scores.group(:value).count
      @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    when "1" then
      @score = @user.scores.group(:all).count
      @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    when "2" then
      @score = @user.scores.group(:story).count
      @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    when "3" then
      @score = @user.scores.group(:animation).count
      @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    when "4" then
      @score = @user.scores.group(:performance).count
      @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    when "5" then
      @score = @user.scores.group(:music).count
      @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    when "6" then
      @score = @user.scores.group(:character).count
      @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    end
    puts @pss
    puts @pss.map{|key,value|value}
    render json:{score_arrayies:@pss.map{|key,value|value}}
  end

  def destroy
    begin
      @user = User.find(params[:id])
      @user.destroy
      render json:{status:200}
    rescue => e
      puts e
      render json:{status:500}
    end


  end

  private
  def update_params
    params.require(:user).permit(:nickname)
  end

  def background_params
    params.require(:user).permit(:background_image)
  end

  def background_params2
    params.permit(:bg_img)
  end

  def overview_params
    params.require(:user).permit(:overview)
  end
end
class Api::V1::ProductsController < ApplicationController
  # before_action :authenticate_api_v1_user!, only: :red
  def left
    @styles = Style.all.includes(:products)
    @genres = Janl.all.includes(:products)
    render :left,formats: :json
  end


 

  def index
    # ota
    @products = Product.all.where(finished:0).limit(30)
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
    @aaa = {
      "10"=> 1,
      "20"=> 2,
      "30"=> 60,
      "40"=> 2,
      "50"=> 10,
      "60"=> 4,
      "70"=> 2,
      "80"=> 1,
      "90"=> 0,
      "100"=> 1,
    }
  
    to = Time.current.at_beginning_of_day
    d = Date.today
    dm = d.month
    month_array = []
    month_hash = {}
      (1..12).each do |i|
        i=dm+i
        if i > 12
          i = i-12
        end
        month_array.push(i)
        month_hash[i] = 0
      end

    from  = (to - 1.year).next_month.beginning_of_month
    @acsesses = Product.find(11).acsesses.where(date: from...to).group(:date).sum(:count)
    oei= Product.find(11).scores.average(:value)

    render json: {
      dm:dm,
      month_array:month_array,
      month_hash:month_hash,
      from:from,
      to:to,
      acsess:@acsesses,
      a:oei
    }
  end

  def search()
    puts @grid
  end

  def red
    # ota
    @products = Product.all
    render json: {products: @products,message:"ae"}
  end

  def show
    begin
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

    if current_user
      @liked = current_user.already_liked?(params[:id])
      @scored = current_user.scores.exists?(product_id: params[:id])
      if @liked
        @like = Like.find_by(product_id: params[:id], user_id: current_user.id)
      end
      if @scored
        @score = Score.find_by(product_id: params[:id], user_id: current_user.id)
      end
    else
      @liked = false
      @scored = false
    end
    @product = Product.find(params[:id])
    @stats = @product.scores.group(:value).count
    @stats.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    @stats_array = []
    @pss.map{|key,value|@stats_array.push(@pss[key])}

    to = Time.current.at_beginning_of_day
    to2 = Time.current.end_of_day
    d = Date.today
    dm = d.month
    @month_array = []
    @month_hash = {}
      (1..12).each do |i|
        i=dm+i
        if i > 12
          i = i-12
        end
        @month_array.push(i)
        @month_hash[i] = 0
      end

    from  = (to - 1.year).next_month.beginning_of_month
    @acsesses = Product.find(params[:id]).acsesses.where(date: from...to2).group(:date).sum(:count)
    @acsesses.map{|key,value|@month_hash[key.month]=value}
    @acsesses_array = []
    @month_hash.map{|key,value|@acsesses_array.push(@month_hash[key])}

    # 追加
    if @product.scores.exists?
      @average_score = @product.scores.average(:value).round(1)
    end
    @like_count = @product.likes.count

  
    @quesion = Question.all

    d2 = Time.current
    to3 =  d.since(7.days)
    # 2.0
    @episord = @product.episords.where(release_date:d2...to3).order(release_date: :asc).limit(1)
    @character = Character.where(product_id:@product.id).includes(:cast)
    @staff = @product.occupations.includes(:staff)
    @yearSeason = Year.left_outer_joins(:year_season_products).includes(:year_season_products,:year_season_seasons).where(year_season_products:{product_id:@product.id}).order(year: :asc).distinct

    if current_user
      @userEpisord = current_user.reviews.includes(:emotions).where(product_id:@product.id,user_id:current_user.id)
    end
    @emotions = Emotion.all
    #emotionList
    @emotionList = @product.emotions.includes(:review_emotions).group(:emotion_id).order("count(emotion_id) desc")
    @emotionList.count


    render :show,formats: :json
    rescue
      render json:{status:500}
    end
  end 


  def create
    @product = Product.where(title:params[:product][:title]).first_or_initialize
      @product.image_url = params[:product][:image_url]
      @product.description = params[:product][:description]
      @product.list = params[:product][:list]
      @product.year = params[:product][:year]
      @product.year2 = "#{params[:product][:year]}-01-01"
      @product.delivery_start = params[:product][:delivery_start]
      @product.delivery_end = params[:product][:delivery_end]
      @product.image_url2 = params[:product][:image_url2] 
      @product.titleKa = params[:product][:image_url3] 
      @product.titleEn = params[:product][:image_urlh1] 
      @product.titleRo = params[:product][:image_urlh2] 
      @product.wiki = params[:product][:image_urlh3] 

      @product.wikiEn = params[:product][:wikiEn] 
      @product.copyright = params[:product][:copyright] 
      @product.annitict = params[:product][:annitict_id] 
      @product.shoboiTid = params[:product][:shoboi_tid] 



      @product.janl_ids = params[:genres_array]
      @product.kisetsu_ids = params[:product][:kisetsu]
      @product.studio_ids = params[:studios_array]
      @product.style_ids = params[:formats_array]

    # doneyet-1 (下@product.saveと同時に)
    params[:episord].each do |i|
      @episord = Episord.where(episord:i[:episord_number],product_id:@product.id).first_or_initialize
        @episord.title = i[:episord_tittle]
        @episord.arasuzi = i[:episord_arasuzi]
        @episord.image = i[:episord_image_url]
        @episord.time = i[:episord_time]
        @episord.release_date =i[:episord_release_date]
        @episord.save
    end

    params[:staff_middle].each do |s|
      @staff = Occupation.where(staff_id:s[:cast_id],product_id:@product.id).first_or_initialize
      @staff.name = s[:character_name]
      @staff.save
    end
    

    params[:character_middle_data].each do |c|
      @character = Character.where(cast_id:c[:cast_id],product_id:@product.id,name:c[:character_name]).first_or_initialize
      @character.image = c[:character_image]
      @character.save
    end

    yearSeason = []  
    params[:product][:year_season].each do |y|
      year_id = Year.where(year:"#{y[:year]}-01-01")[0].id
      y[:season].each do |s|
        @yearSeason = YearSeasonProduct.where(product_id:@product.id,kisetsu_id:s,year_id:year_id).first_or_initialize
        yearSeason << @yearSeason
      end
    end
    @product.year_season_products = yearSeason
    begin
      if params[:product][:image_url].present?
        file = open(params[:product][:image_url])
        puts file.base_uri
        @product.bg_images.attach(io: file, filename: "gorld_field/#{@product.id}")
      end
    rescue => exception
        
    else
      
    end
    @product.save 
  end

  def edit1
    @product = Product.find(params[:id])
    @year = Year.left_outer_joins(:year_season_products).includes(:year_season_seasons).where(year_season_products:{product_id:@product.id}).order(year: :asc).distinct
    @yearSeason = YearSeasonProduct.where(product_id:@product.id)
    render :edit1,formats: :json
  end

  def update
    years = []
    params[:product][:years].each do |y|
      year = Year.where(year:"#{y}-01-01").first_or_initialize
      year.save
      years<<year.id
    end

    @product = Product.where(id:params[:id]).first_or_initialize
    @product.title = params[:product][:title]
    @product.image_url = params[:product][:image_url]
    @product.description = params[:product][:description]
    @product.list = params[:product][:list]
    @product.year = params[:product][:year]
    @product.year2 = "#{params[:product][:year]}-01-01"
    @product.delivery_start = params[:product][:delivery_start]
    @product.delivery_end = params[:product][:delivery_end]
    @product.image_url2 = params[:product][:image_url2] 
    @product.titleKa = params[:product][:image_url3] 
    @product.titleEn = params[:product][:image_urlh1] 
    @product.titleRo = params[:product][:image_urlh2] 
    @product.wiki = params[:product][:image_urlh3] 

    @product.wikiEn = params[:product][:wikiEn] 
    @product.copyright = params[:product][:copyright] 
    @product.annitict = params[:product][:annitict_id] 
    @product.shoboiTid = params[:product][:shoboi_tid] 

    @product.overview = params[:product][:overview]

    @product.janl_ids = params[:genres_array]
    @product.kisetsu_ids = params[:product][:kisetsu]
    @product.studio_ids = params[:studios_array]
    @product.style_ids = params[:formats_array]
    @product.year_ids = years
    
    episord = []
    params[:episord].each do |i|
      @episord = Episord.where(episord:i[:episord_number],product_id:@product.id).first_or_initialize
      @episord.title = i[:episord_tittle]
      @episord.arasuzi = i[:episord_arasuzi]
      @episord.image = i[:episord_image_url]
      @episord.time = i[:episord_time]
      @episord.release_date =i[:episord_release_date]
      @episord.save
      episord<<@episord
    end
    @product.episords = episord

    staff = []
    params[:staff_middle].each do |s|
      @staff = Occupation.where(staff_id:s[:cast_id],product_id:@product.id).first_or_initialize
      @staff.name = s[:character_name]
      @staff.save
      staff << @staff
    end
    @product.occupations = staff
  
    character = []
    params[:character_middle_data].each do |c| 
      if c[:id].nil?
        @character = Character.where(cast_id:c[:cast_id],product_id:@product.id,name:c[:character_name]).first_or_initialize
        @character.image = c[:character_image]
        @character.save
      else
        @character = Character.where(id:c[:id],cast_id:c[:cast_id],product_id:@product.id).first_or_initialize
        @character.name = c[:character_name]
        @character.image = c[:character_image]
        @character.save
      end
      character << @character

    end
    @product.characters = character

    yearSeason = []  
    params[:product][:year_season].each do |y|
      year_id = Year.where(year:"#{y[:year]}-01-01")[0].id
     
      y[:season].each do |s|
        @yearSeason = YearSeasonProduct.where(product_id:@product.id,kisetsu_id:s,year_id:year_id).first_or_initialize
        yearSeason << @yearSeason
      end
    end

    @product.year_season_products = yearSeason

    begin
      if params[:product][:image_url].present?
        file = open(params[:product][:image_url])
        puts file.base_uri
        @product.bg_images.attach(io: file, filename: "gorld_field/#{@product.id}")
      end
    rescue => exception
        
    else
      
    end

    @product.save


  end 

  def product_episords
    @product = Product.find(params[:product_id])
    @episords = @product.episords.includes(:emotions).includes(weeks: :weeklyrankings)
    render :product_episords,formats: :json
  end

  def product_review
    @product = Product.find(params[:product_id])
    if params[:episords].present?
      if params[:episords].length>0
        @reviews = @product.reviews.where(episord_id:params[:episords]).order(updated_at: :desc).page(params[:page]).per(2)
        @length = @product.reviews.where(episord_id:params[:episords]).size
      else
        @reviews = @product.reviews.order(updated_at: :desc).page(params[:page]).per(2)
        @length = @product.reviews.size
      end
    else
      @reviews = @product.reviews.order(updated_at: :desc).page(params[:page]).per(2)
      @length = @product.reviews.size
    end
      render :product_review ,formats: :json
  end

  def product_thread
    @product = Product.find(params[:product_id])
    @reviews = @product.thereds.order(updated_at: :desc).page(params[:page]).per(2)
    @length = @product.thereds.size
    render :product_thread ,formats: :json
  end

  def seo
    @product = Product.find(params[:id])
    render :seo,formats: :json
  end

  private
    def user_params
      params.require(:review).permit(:content).merge(product_id:11,user_id:3,title:"aaa")
    end
    # def create_params
    #   # params.require(:products).permit(:title,:image_url,:description,:list,)
    # end
end

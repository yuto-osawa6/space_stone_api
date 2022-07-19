class Api::V1::ProductsController < ApplicationController
  # before_action :authenticate_api_v1_user!, only: :red
  # before_action :check_user_logined, only:[:compare_tier]
  def left
    # doneyet-1 n+1
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
    # puts request.remote_ip

    # 次の２種類の方法がある
    puts "0"

    puts request.env["HTTP_X_FORWARDED_FOR"]
    puts "1"
    puts request.remote_ip
    puts "2"
    
    # １つ目で取得に失敗したら２つ目を試せる、ハイブリッドな書き方
    puts request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
    puts "3"
    
    # こちらを勧めるサイトもあった（参考URLの３）
    # puts request.env["HTTP_X_FORWARDED_FOR"].split(",")[0] || request.remote_ip


    @products = Product.all
    render json: {message:"aaa"}
    # render json: {}

    # @product = Product.find(1)
    # if @product.scores.length>0
    # average = @product.scores.average(:value).round(1)
    # else
    # average = 0
    # end
    # image = OgpCreator.build(@product.bg_images,@product,average).tempfile.open.read
    # send_data image, :type => 'image/png',:disposition => 'inline'


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

    # @admin = User
    @admin = User.find_by(email:"meruplanet.sub@gmail.com")
    @productReviews = @product.reviews.includes(:like_reviews).left_outer_joins(:like_reviews).group("reviews.id").order(Arel.sql("sum(CASE WHEN goodbad = 1 THEN 1 ELSE 0 END)/count(goodbad) desc")).limit(4)
    # @product.thereds.
    @entThread = @admin.thereds.where(product_id:@product.id,episord_id:nil).limit(1)
    @entThread2 =  @admin.thereds.where.not(id:@entThread.ids).left_outer_joins(:episord).where(product_id:@product.id).order('episord.episord desc').limit(4 - @entThread.length)
    @productThreads = @entThread + @entThread2
    # @reviews = @admin.thereds.left_outer_joins(:episord).where(product_id:params[:product_id]).order('episord.episord desc').limit(4)
    


    render :show,formats: :json
    rescue
      render json:{status:500}
    end
  end 

  # doneyet-1 statusがオーバーライトされる
  def create
    # render json:{status:490}
    begin
      @product = Product.where(title:params[:product][:title]).first_or_initialize

      if !@product.new_record?
        render json:{status:390}
        return
      end

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
      @product.arasuzi_copyright = params[:product][:arasuzi_copyright]


      @product.janl_ids = params[:genres_array]
      @product.kisetsu_ids = params[:product][:kisetsu]
      @product.studio_ids = params[:studios_array]
      @product.style_ids = params[:formats_array]



  

      
      @style = Style.where(id:params[:formats_array])[0]
      # @style.save
      # @product.style_ids = @style.id
      @user = User.find_by(email:"meruplanet.sub@gmail.com")
      # if @style.name == "映画" || @style.name == "アニメ"
        @thread = Thered.where(product_id:@product.id,episord_id:nil).first_or_initialize
        @thread.title = "#{@product.title}"
        @thread.question_ids = [2,4]
        @thread.user_id = @user.id
        @thread.content = "<p>#{@product.title}を見た感想をお書cきください。</p>"
        @thread.save
      # end

      # # doneyet-1 (下@product.saveと同時に)
      params[:episord].each do |i|
        @episord = Episord.where(episord:i[:episord_number],product_id:@product.id).first_or_initialize
          @episord.title = i[:episord_tittle]
          @episord.arasuzi = i[:episord_arasuzi]
          @episord.image = i[:episord_image_url]
          @episord.time = i[:episord_time]
          @episord.release_date =i[:episord_release_date]
          @episord.save
      end

      # params[:staff_middle].each do |s|
      #   @staff = Occupation.where(staff_id:s[:cast_id],product_id:@product.id).first_or_initialize
      #   @staff.name = s[:character_name]
      #   @staff.save
      # end
      staff = []
      params[:staff_middle].each do |s|
        @staff = Occupation.where(staff_id:s[:cast_id],product_id:@product.id).first_or_initialize
        @staff.name = s[:character_name]
        # @staff.save
        staff << @staff
      end
      @product.occupations = staff

      character = []
      params[:character_middle_data].each do |c| 
        @character = Character.where(cast_id:c[:cast_id],product_id:@product.id,name:c[:character_name]).first_or_initialize
        @character.image = c[:character_image]
        # @character.save
        character << @character
      end
      @product.characters = character
    

      # params[:character_middle_data].each do |c|
      #   @character = Character.where(cast_id:c[:cast_id],product_id:@product.id,name:c[:character_name]).first_or_initialize
      #   @character.image = c[:character_image]
      #   @character.save
      # end

      yearSeason = []  
      params[:product][:year_season].each do |y|
        year = Year.where(year:"#{y[:year]}-01-01").first_or_initialize
        if year.new_record?
          year.save
        end
        # year_id = Year.where(year:"#{y[:year]}-01-01")[0].id
        year_id = year.id
        y[:season].each do |s|
          @yearSeason = YearSeasonProduct.where(product_id:@product.id,kisetsu_id:s,year_id:year_id).first_or_initialize
          yearSeason << @yearSeason
        end
      end
      @product.year_season_products = yearSeason
      if !@product.bg_images.attached?
        if params[:product][:image_url].present?
          file = open(params[:product][:image_url])
          @product.bg_images.attach(io: file, filename: "meruplanet/#{}")
        end
      end
      if !@product.bg_images.attached?
        if params[:product][:image_url2].present?
          file = open(params[:product][:image_url2])
          @product.bg_images2.attach(io: file, filename: "meruplanet/#{}")
        end
      end
      @product.save 
      render json:{status:200}
    rescue
      render json:{status:501}
    end
  end

  def edit1
    @product = Product.find(params[:id])
    @year = Year.left_outer_joins(:year_season_products).includes(:year_season_seasons).where(year_season_products:{product_id:@product.id}).order(year: :asc).distinct
    @yearSeason = YearSeasonProduct.where(product_id:@product.id)
    render :edit1,formats: :json
  end

  def update
    begin
    years = []
    params[:product][:years].each do |y|
      year = Year.where(year:"#{y}-01-01").first_or_initialize
      year.save
      years<<year.id
    end
    puts params[:product][:delivery_start]
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
    @product.arasuzi_copyright = params[:product][:arasuzi_copyright]

    @product.janl_ids = params[:genres_array]
    @product.kisetsu_ids = params[:product][:kisetsu]
    @product.studio_ids = params[:studios_array]
    @product.style_ids = params[:formats_array]
    @product.year_ids = years
    
    # episord = []
    # params[:episord].each do |i|
    #   @episord = Episord.where(episord:i[:episord_number],product_id:@product.id).first_or_initialize
    #   @episord.title = i[:episord_tittle]
    #   @episord.arasuzi = i[:episord_arasuzi]
    #   @episord.image = i[:episord_image_url]
    #   @episord.time = i[:episord_time]
    #   @episord.release_date =i[:episord_release_date]
    #   @episord.save
    #   episord<<@episord
    # end
    # @product.episords = episord

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
      year = Year.where(year:"#{y[:year]}-01-01").first_or_initialize
      if year.new_record?
        year.save
      end
      year_id = year.id
     
      y[:season].each do |s|
        @yearSeason = YearSeasonProduct.where(product_id:@product.id,kisetsu_id:s,year_id:year_id).first_or_initialize
        yearSeason << @yearSeason
      end
    end

    @product.year_season_products = yearSeason

     
        if !@product.bg_images.attached?
          if params[:product][:image_url].present?
            puts "iaijeoifai0"
            file = open(params[:product][:image_url])
            puts file.base_uri
            @product.bg_images.attach(io: file, filename: "meruplanet/#{}")
            puts "iaijeoifai1"
          end
          puts "iaijeoifai2"
        end
        puts "iaijeoifai"
        if !@product.bg_images.attached?
          if params[:product][:image_url2].present?
            file = open(params[:product][:image_url2])
            puts file.base_uri
            @product.bg_images2.attach(io: file, filename: "meruplanet/#{}")
            puts "afjeioafjeioa1"
          end
          puts "afjeioafjeioa2"
        end
        puts "afjeioafjeioa3"
        @product.save
        render json:{status:200}
      rescue => e
        puts "afjeioafjeioa5"
        puts e
        render json:{status:500}
      end

    


  end 

  def product_episords
    @product = Product.find(params[:product_id])
    @episords = @product.episords.includes(:emotions).includes(weeks: :weeklyrankings).order(episord: :asc).page(params[:page]).per(Concerns::PAGE[:episord])
    @episordsLength = @product.episords.length
    render :product_episords,formats: :json
  end

  def product_review
    @product = Product.find(params[:product_id])
    if params[:episords].present?
      if params[:episords].length>0
        @reviews = @product.reviews.where(episord_id:params[:episords]).order(updated_at: :desc).page(params[:page]).per(Concerns::PAGE[:episord])
        @length = @product.reviews.where(episord_id:params[:episords]).size
      else
        @reviews = @product.reviews.order(updated_at: :desc).page(params[:page]).per(Concerns::PAGE[:episord])
        @length = @product.reviews.size
      end
    else
      @reviews = @product.reviews.order(updated_at: :desc).page(params[:page]).per(Concerns::PAGE[:episord])
      @length = @product.reviews.size
    end
      render :product_review ,formats: :json
  end

  def product_thread
    @product = Product.find(params[:product_id])
    # @user = User.find_by(email:"meruplanet.sub@gmail.com")
    @admin = User.find_by(email:"meruplanet.sub@gmail.com")
    @reviews = @product.thereds.where.not(user_id:@admin.id).order(updated_at: :desc).page(params[:page]).per(Concerns::PAGE[:episord])
    # @official = @admin.thereds.left_outer_joins(:episord).where(product_id:144).order('episord.episord desc').per(Concerns::PAGE[:episord])
    @length = @product.thereds.where.not(user_id:@admin.id).size
    # @official_length = @admin.thereds.size
    render :product_thread ,formats: :json

    # @admin.thereds.left_outer_joins(:episord).where(product_id:144).order('episord.episord desc').length
  end

  def product_thread_official
    @product = Product.find(params[:product_id])
    # @user = User.find_by(email:"meruplanet.sub@gmail.com")
    @admin = User.find_by(email:"meruplanet.sub@gmail.com")
    # @reviews = @product.thereds.where.not(user_id:@admin.id).order(updated_at: :desc).page(params[:page]).per(Concerns::PAGE[:episord])
    @reviews = @admin.thereds.left_outer_joins(:episord).where(product_id:params[:product_id]).order('episord.episord desc').page(params[:page]).per(Concerns::PAGE[:episord])
    # @length = @product.thereds.where.not(user_id:@admin.id).size
    @length = @admin.thereds.where(product_id:params[:product_id]).size
    render :product_thread_official ,formats: :json
  end

  def seo
    @product = Product.find(params[:id])
    if !Product.exists?(id:params[:id])
      render json:{status:500}
      return
    end
    
    if user_signed_in?
      if current_user.administrator_gold == true
      else
        if @product.finished == false
          render json:{status:500}
          return
        end
      end
    else
      if @product.finished == false
        render json:{status:500}
        return
      end
    end
    
    render :seo,formats: :json
  end

  # compare
  def compare_score
    # notest
    @product = Product.find(params[:id])
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

    case params[:index]
    when "0" then
      @score = @product.scores.group(:value).count
      @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    when "1" then
      @score = @product.scores.group(:all).count
      @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    when "2" then
      @score = @product.scores.group(:story).count
      @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    when "3" then
      @score = @product.scores.group(:animation).count
      @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    when "4" then
      @score = @product.scores.group(:performance).count
      @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    when "5" then
      @score = @product.scores.group(:music).count
      @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    when "6" then
      @score = @product.scores.group(:character).count
      @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    end
    render json:{score_arrayies:@pss.map{|key,value|value}}
  end

  # alice-1 複数コード
  def compare_emotion
    if params[:episord_id] != "0"
      # episord = Episord.find(params[:episord_id]).emotions
      # episord = Episord.find(1).emotions.group("id").order(Arel.sql('count(emotions.id) DESC')).count
      episord = Episord.find(params[:episord_id]).emotions.group("emotion").order(Arel.sql('count(emotions.id) DESC')).count
      
      # episord = Episord.find(params[:episord_id]).emotions.group("id").count
    else
      # episord = Review.where(episord_id:nil,product_id:1).includes(:emotions).map(&:emotions)
      # episord_id = Review.where(episord_id:nil,product_id:1).includes(:emotions).map(&:emotions).flatten.map(&:id)
      # Emotion.where()
      # Review.where(episord_id:nil,product_id:1).includes(:emotions).map(&:emotions).flatten.map(&:id)
      episord = Review.where(episord_id:nil,product_id:params[:product_id]).includes(:emotions).map(&:emotions).flatten.map(&:emotion).tally.sort_by { |_, v| v }.reverse.to_h
      # episord = Review.where(episord_id:nil,product_id:params[:product_id]).includes(:emotions).map(&:emotions).flatten.map(&:id).tally

      puts episord
    end
    # episord.values
    if(episord.keys[10..-1]).blank?
      render json:{emotionsKey:episord.keys[0..9],emotionsValue:episord.values[0..9].map{|a|(a/episord.values.sum().to_f*100).round(1)}}
    else
      render json:{emotionsKey:episord.keys[0..9].push("その他"),emotionsValue:episord.values[0..9].push(episord.values[10..-1].sum())}
    end
    # if(episord.keys[2..-1]).blank?
    #   render json:{emotionsKey:episord.keys[0..1],emotionsValue:episord.values[0..1]}
    # else
    #   render json:{emotionsKey:episord.keys[0..1].push("その他"),emotionsValue:episord.values[0..1].push(episord.values[2..-1].sum())}
    # end
  end

  def compare_tier
    @pss = {
      "0"=> 0,
      "20"=> 0,
      "40"=> 0,
      "60"=> 0,
      "80"=> 0,
      "100"=> 0,
    } 
    @product = Product.find(params[:id])
    @tier = @product.tiers.where(tier_group_id:params[:alice]).group(:tier).count
    @tier.map {|key,value|@pss["#{key}"] = value}

    if !params[:user_id].blank?
      @user = User.find(params[:user_id])
      @user_tier = Tier.where(user_id:params[:user_id],product_id:params[:product_id],tier_group_id:params[:alice])
      if !@user_tier.blank?
        case @user_tier[0].tier
        when 0 then
          @user_tier = "E"
        when 20 then
          @user_tier = "D"
        when 40 then
          @user_tier = "C"
        when 60 then
          @user_tier = "B"
        when 80 then
          @user_tier = "A"
        when 100 then
          @user_tier = "S"
        else
          @user_tier = nil
        end
      else
        @user_tier = nil
      end
    else
      @user_tier = nil
    end

    render json:{values:@pss.values,user_tier:@user_tier,status:200}

  end

  private
  def user_params
    params.require(:review).permit(:content).merge(product_id:11,user_id:3,title:"aaa")
  end
end


